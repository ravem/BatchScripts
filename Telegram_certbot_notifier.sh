#!/bin/sh

KEY="INSERT_YOUR_KEY_HERE"

URL="https://api.telegram.org/bot$KEY/sendMessage"

CERTBOT_LOG_FILE="/var/log/certbot_telegram.log"

TARGET="INSERT_CHAT_ID_HERE" # Telegram ID of the conversation with the bot, get it from /getUpdates API

#this is the actual renew script, assuming you are using, as me, nginx :-)
certbot renew -w /var/appdata/ --pre-hook "systemctl stop nginx" --post-hook "systemctl start nginx" | tee ${CERTBOT_LOG_FILE}

TEXT="certbot renewal task run log:
+++++++++++++++++++++++++++++++++++
$(cat /var/log/certbot_telegram.log)
+++++++++++++++++++++++++++++++++++
Check for errors."

#Here you build the message to send
MESSAGE="chat_id=$TARGET&text=$TEXT&disable_web_page_preview=true"

#Here you send the mesage
curl -s --max-time 10 --retry 5 --retry-delay 2 --retry-max-time 10 -d "$MESSAGGIO" $URL > /dev/null 2>&1 &
