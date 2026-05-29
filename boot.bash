#!/usr/bin/env bash
set -uo pipefail

DISCORD_BOT_TOKEN="${DISCORD_BOT_TOKEN:-00000000:xxxxxxxxxxxxxxxxxxxxxxxxxxxx}"
DISCORD_CHANNEL_ID="${DISCORD_CHANNEL_ID:-xxxxxxxxxxx}"

notify_discord() {
  local -r text="$1"
  [[ -z "${DISCORD_BOT_TOKEN}" || -z "${DISCORD_CHANNEL_ID}" ]] && return 0
  curl -s -X POST \
    -H "Authorization: Bot ${DISCORD_BOT_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"content\":\"${text}\"}" \
    "https://discord.com/api/v10/channels/${DISCORD_CHANNEL_ID}/messages" \
    > /dev/null 2>&1 || true
}

declare -i restart_count=0
while true; do
  if (( restart_count == 0 )); then
    notify_discord "🦐 ニルカニちゃん六世を起動します🌅"
  else
    notify_discord "🦐 ニルカニちゃん六世が終了 → 5秒後に再起動します🔄"
    sleep 5
    notify_discord "🦐 ニルカニちゃん六世を再起動します🌅"
  fi
  (( restart_count++ )) || true
  claude --dangerously-skip-permissions --channels plugin:discord@claude-plugins-official -c || true
  printf '[%s] ニルカニちゃん六世が終了しました。5秒後に再起動します...\n' "$(date -Iseconds)"
done
