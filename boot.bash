#!/usr/bin/env bash
set -euo pipefail

export DISCORD_TOKEN="${DISCORD_TOKEN:-}"
export DISCORD_WEBHOOK_URL="${DISCORD_WEBHOOK_URL:-}"
export GROQ_API_KEY="${GROQ_API_KEY:-gsk_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx}"

notify_discord() {
  local text="$1"
  [[ -n "$DISCORD_WEBHOOK_URL" ]] || return 0
  curl -s -X POST "$DISCORD_WEBHOOK_URL" \
    -H "Content-Type: application/json" \
    -d "{\"content\": \"${text}\"}" \
    > /dev/null 2>&1 || true
}

first=true
while true; do
  if $first; then
    notify_discord "🦐 boot.bash起動: ニルカニを起動します🌅"
    first=false
  else
    notify_discord "🦐 ニルカニが終了 → 5秒後に再起動します🔄"
    sleep 5
    notify_discord "🦐 ニルカニを再起動します🌅"
  fi
  node bot.js || true
  echo "ニルカニが終了しました。5秒後に再起動します..."
done
