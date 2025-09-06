#!/bin/bash

CPU_THRESHOLD=80
DISK_THRESHOLD=85
LOAD_THRESHOLD=2.0
RAM_THRESHOLD=90

SECRETS_FILE="$HOME/.config/server/secrets.sh"

if [ -f "$SECRETS_FILE" ]; then
  source "$SECRETS_FILE"
else
  echo "[ERR] Secrets file not found: $SECRETS_FILE" >&2
  echo "Please, create the file." >&2
  exit 1
fi

send_telegram() {
  local hostname=$(hostname)
  local message="$1"

  if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
    echo "[ERR] Telegram secrets not found." >&2
    echo "Please, add them to the file." >&2
    exit 1
  fi

  local formatted_message="🚨 *$hostname*%0A%0A$message"

  curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
    -d "chat_id=$TELEGRAM_CHAT_ID" \
    -d "text=$formatted_message" \
    -d "parse_mode=Markdown" \
    -d "disable_web_page_preview=true" > /dev/null 2>&1
}

check_cpu() {
  local cpu_usage=$(/usr/bin/top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 | cut -d' ' -f1)
  cpu_usage=${cpu_usage%.*}

  if [ "$cpu_usage" -gt "$CPU_THRESHOLD" ]; then
    send_telegram "⚡ *High CPU*%0ACPU: ${cpu_usage}% (limit: ${CPU_THRESHOLD}%)"

    return 1
  fi

  return 0
}

check_ram() {
  local ram_usage=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100.0)}')

  if [ "$ram_usage" -gt "$RAM_THRESHOLD" ]; then
    local ram_used=$(free -h | grep Mem | awk '{print $3}')
    local ram_total=$(free -h | grep Mem | awk '{print $2}')
    local swap_used=$(free -h | grep Swap | awk '{print $3}')

    send_telegram "💾 *High RAM*%0ARAM: ${ram_usage}% (${ram_used}/${ram_total})%0ASwap used: ${swap_used}"

    return 1
  fi

  return 0
}

check_disk() {
  local disk_usage=$(df / | tail -1 | awk '{print $5}' | cut -d'%' -f1)

  if [ "$disk_usage" -gt "$DISK_THRESHOLD" ]; then
    local disk_info=$(df -h / | tail -1 | awk '{print $3 " of " $2 " used"}')

    send_telegram "💿 *Disk is full*%0ADisk: ${disk_usage}% (${disk_info})"

    return 1
  fi

  return 0
}

check_load() {
  local load_1min=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | xargs)

  if (( $(echo "$load_1min > $LOAD_THRESHOLD" | bc -l) )); then
    local load_5min=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $2}' | xargs)

    send_telegram "⚖️ *High load*%0ALoad 1min: ${load_1min}%0ALoad 5min: ${load_5min}%0ALimit: ${LOAD_THRESHOLD}"

    return 1
  fi

  return 0
}

get_stats() {
  local cpu_usage=$(/usr/bin/top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 | cut -d' ' -f1)
  local ram_usage=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100.0)}')
  local disk_usage=$(df / | tail -1 | awk '{print $5}' | cut -d'%' -f1)
  local load_1min=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | xargs)

  echo "📊 *System status*%0A%0A🔥 CPU: ${cpu_usage}%%0A💾 RAM: ${ram_usage}%%0A💿 Disk: ${disk_usage}%%0A⚖️ Load: ${load_1min}%0A%0A✅ Everything in order"
}

main() {
  local issues=0

  check_cpu || ((issues++))
  check_ram || ((issues++))
  check_disk || ((issues++))
  check_load || ((issues++))

  return $issues
}

install_monitor() {
  echo "🚀 Installing system monitor..."

  sudo apt update
  sudo apt install -y bc curl

  (crontab -l 2>/dev/null | grep -v system-monitor; echo "*/5 * * * * /home/inigo/.scripts.d/system-monitor.sh") | crontab -

  echo "✅ Monitor installed!"
  echo ""
  echo "🔧 CONFIGURE TELEGRAM:"
  echo "1. Speak to @BotFather in Telegram"
  echo "2. Create a bot: /newbot"
  echo "3. Copy the token"
  echo "4. Speak to @userinfobot for your chat_id"
  echo ""
  echo "✨ Useful commands:"
  echo "   Manual test: /home/inigo/.scripts.d/system-monitor.sh"
  echo "   Estado: /home/inigo/.scripts.d/system-monitor.sh status"
}

show_status() {
  echo "📊 Current system state:"
  echo "CPU: $(/usr/bin/top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 | cut -d' ' -f1)%"
  echo "RAM: $(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100.0)}')%"
  echo "Disk: $(df / | tail -1 | awk '{print $5}')"
  echo "Load: $(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | xargs)"
}

send_status() {
  local stats=$(get_stats)
  send_telegram "$stats"
}

case "$1" in
  "install")
    install_monitor
    exit 0
    ;;
  "status")
    show_status
    exit 0
    ;;
  "test")
    send_status
    exit 0
    ;;
  "")
    main
    exit $?
    ;;
  *)
    echo "Usage: $0 [install|status|test]"
    echo "  install - Install the monitor"
    echo "  status  - Show current status"
    echo "  test    - Send status via Telegram"
    exit 1
    ;;
esac
