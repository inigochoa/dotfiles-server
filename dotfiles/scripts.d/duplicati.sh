#!/bin/bash

if [ "$DUPLICATI__PARSED_RESULT" == "Warning" ]; then
  EMOJI="⚠️"
  STATUS="$EMOJI Completed with warnings"
else
  EMOJI="🚨"
  STATUS="$EMOJI Failed"
fi

MESSAGE="$EMOJI <b>Duplicati Backup Report</b>
━━━━━━━━━━━━━━━━
📊 <b>Status:</b> $STATUS
📦 <b>Task:</b> $DUPLICATI__BACKUP_NAME
⚙️ <b>Operation:</b> $DUPLICATI__OPERATIONNAME
⏱️ <b>Duration:</b> $DUPLICATI__DURATION"

if [ -n "$DUPLICATI__ERROR_MESSAGE" ]; then
  MESSAGE="$MESSAGE
🚨 <b>Error:</b> $DUPLICATI__ERROR_MESSAGE"
fi

MESSAGE="$MESSAGE
⏰ $(date '+%Y-%m-%d %H:%M:%S')"

~/.scripts.d/telegram-notify.sh "${MESSAGE}"
