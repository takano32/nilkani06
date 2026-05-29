#!/usr/bin/env bash
set -euo pipefail

export SLACK_BOT_TOKEN="${SLACK_BOT_TOKEN:-xoxb-xxxxxxxxxxxx-xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxx}"
export SLACK_APP_TOKEN="${SLACK_APP_TOKEN:-xapp-x-xxxxxxxxxxxx-xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx}"
export SLACK_NOTIFY_CHANNEL="${SLACK_NOTIFY_CHANNEL:-C00000000}"
export GROQ_API_KEY="${GROQ_API_KEY:-gsk_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx}"

notify_slack() {
  local text="$1"
  [[ -n "$SLACK_BOT_TOKEN" && -n "$SLACK_NOTIFY_CHANNEL" ]] || return 0
  curl -s -X POST "https://slack.com/api/chat.postMessage" \
    -H "Authorization: Bearer ${SLACK_BOT_TOKEN}" \
    --data-urlencode "channel=${SLACK_NOTIFY_CHANNEL}" \
    --data-urlencode "text=${text}" \
    > /dev/null 2>&1 || true
}

first=true
while true; do
  if $first; then
    notify_slack "🦐 boot.bash起動: ニルカニを起動します🌅"
    first=false
  else
    notify_slack "🦐 ニルカニが終了 → 5秒後に再起動します🔄"
    sleep 5
    notify_slack "🦐 ニルカニを再起動します🌅"
  fi
  node bot.js || true
  echo "ニルカニが終了しました。5秒後に再起動します..."
done
