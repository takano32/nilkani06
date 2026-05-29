#!/bin/sh

export SLACK_BOT_TOKEN="${SLACK_BOT_TOKEN:-xoxb-xxxxxxxxxxxx-xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxx}"
export SLACK_APP_TOKEN="${SLACK_APP_TOKEN:-xapp-x-xxxxxxxxxxxx-xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx}"
export SLACK_NOTIFY_CHANNEL="${SLACK_NOTIFY_CHANNEL:-C00000000}"
export OPENAI_API_KEY="${OPENAI_API_KEY:-sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx}"

notify_slack() {
  text="$1"
  if [ -n "$SLACK_BOT_TOKEN" ] && [ -n "$SLACK_NOTIFY_CHANNEL" ]; then
    curl -s -X POST "https://slack.com/api/chat.postMessage" \
      -H "Authorization: Bearer ${SLACK_BOT_TOKEN}" \
      --data-urlencode "channel=${SLACK_NOTIFY_CHANNEL}" \
      --data-urlencode "text=${text}" \
      > /dev/null 2>&1 || true
  fi
}

FIRST=1
while true; do
  if [ "$FIRST" = "1" ]; then
    notify_slack "🦐 boot.sh起動: ニルカニを起動します🌅"
    FIRST=0
  else
    notify_slack "🦐 ニルカニが終了 → 5秒後に再起動します🔄"
    sleep 5
    notify_slack "🦐 ニルカニを再起動します🌅"
  fi
  node bot.js
  echo "ニルカニが終了しました。5秒後に再起動します..."
done
