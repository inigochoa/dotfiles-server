#!/bin/bash

if [ "$PAM_TYPE" != "close_session" ]; then
  HOSTNAME=$(hostname)

  MESSAGE="🔐 <b>New SSH Login</b>
━━━━━━━━━━━━━━━━
👤 <b>User:</b> ${PAM_USER}
🖥  <b>Server:</b> ${HOSTNAME}
⏰ $(date '+%Y-%m-%d %H:%M:%S')"

  ~/.scripts.d/telegram-notify.sh "${MESSAGE}"
fi
