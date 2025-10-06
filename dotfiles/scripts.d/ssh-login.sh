#!/bin/bash

if [ "$PAM_TYPE" != "close_session" ]; then
  HOSTNAME=$(hostname)
  IP=$(echo $SSH_CONNECTION | awk '{print $1}')

  MESSAGE="🔐 <b>New SSH Login</b>
━━━━━━━━━━━━━━━━
👤 <b>User:</b> ${PAM_USER}
🖥  <b>Server:</b> ${HOSTNAME}
🌍 <b>Source IP:</b> ${IP}
⏰ $(date '+%Y-%m-%d %H:%M:%S')"

  ~/.scripts.d/telegram-notify.sh "${MESSAGE}"
fi
