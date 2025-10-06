#!/bin/bash

HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $1}')

MESSAGE="🚀 <b>Server Started</b>
━━━━━━━━━━━━━━━━
🖥  <b>Host:</b> ${HOSTNAME}
⏰ $(date '+%Y-%m-%d %H:%M:%S')"

~/.scripts.d/telegram-notify.sh "${MESSAGE}"
