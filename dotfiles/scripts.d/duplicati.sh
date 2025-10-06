#!/bin/bash

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

~/.scripts.d/telegram-notify.sh "${MESSAGE}"
