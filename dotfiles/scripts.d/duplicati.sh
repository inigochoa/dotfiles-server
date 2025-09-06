#!/bin/bash

SECRETS_FILE="$HOME/.config/server/secrets.sh"

if [ -f "$SECRETS_FILE" ]; then
  source "$SECRETS_FILE"
else
  echo "[ERR] Secrets file not found: $SECRETS_FILE" >&2
  echo "Please, create the file." >&2
  exit 1
fi

if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
  echo "[ERR] Telegram secrets not found." >&2
  echo "Please, add them to the file." >&2
  exit 1
fi

if [ "$DUPLICATI__PARSED_RESULT" == "Warning" ]; then
  EMOJI="⚠️"
  STATUS="$EMOJI Completed with warnings"
else
  EMOJI="🚨"
  STATUS="$EMOJI Failed"
fi

MESSAGE="$EMOJI *Duplicati Backup Report* $EMOJI
---------------------------------
*Status*: $STATUS
*Task*: $DUPLICATI__BACKUP_NAME
*Operation*: $DUPLICATI__OPERATIONNAME
*Duration*: $DUPLICATI__DURATION

_Completed: $(date)_"

if [ -n "$DUPLICATI__ERROR_MESSAGE" ]; then
  MESSAGE="$MESSAGE

*Error*: $DUPLICATI__ERROR_MESSAGE"
fi

MESSAGE=$(echo "$MESSAGE" | sed 's/\./\\./g' | sed 's/\-/\\-/g' | sed 's/\(/\\(/g' | sed 's/\)/\\)/g')

curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
  -d "chat_id=$TELEGRAM_CHAT_ID" \
  -d "text=$MESSAGE" \
  -d "parse_mode=MarkdownV2" \
  -d "disable_web_page_preview=true" > /dev/null 2>&1
