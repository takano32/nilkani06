#!/usr/bin/env bash
set -uo pipefail

TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-00000000:xxxxxxxxxxxxxxxxxxxxxxxxxxxx}"
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-xxxxxxxxxxx}"

DISCORD_BOT_TOKEN="${DISCORD_BOT_TOKEN:-00000000:xxxxxxxxxxxxxxxxxxxxxxxxxxxx}"
DISCORD_CHANNEL_ID="${DISCORD_CHANNEL_ID:-xxxxxxxxxxx}"

notify_telegram() {
  local -r text="$1"
  #[[ -z "${TELEGRAM_BOT_TOKEN}" || -z "${TELEGRAM_CHAT_ID}" ]] && return 0
  #curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  #  -d "chat_id=${TELEGRAM_CHAT_ID}" \
  #  --data-urlencode "text=${text}" \
  #  > /dev/null 2>&1 || true

  [[ -z "${DISCORD_BOT_TOKEN}" || -z "${DISCORD_CHANNEL_ID}" ]] && return 0
    curl --verbose -X POST \
      -H "Authorization:Bot ${DISCORD_BOT_TOKEN}" \
      -H "Content-Type:application/json" \
      --data-urlencode "{\"content\":\"${text}\"}" \
      ${DISCORD_CHANNEL_ID} \
      https://discord.com/api/v10/channels/${DISCORD_CHANNEL_ID}/messages \
      > /dev/null 2>&1 || true
}

declare -i restart_count=0
while true; do
  if (( restart_count == 0 )); then
    notify_telegram "🦐 boot.sh起動: ナルエビ三世を起動します🌅"
  else
    notify_telegram "🦐 ナルエビ三世が終了 → 5秒後に再起動します🔄"
    sleep 5
    notify_telegram "🦐 ナルエビ三世を再起動します🌅"
  fi
  (( restart_count++ )) || true
  claude --dangerously-skip-permissions --channels plugin:discord@claude-plugins-official -c || true
  printf '[%s] ナルエビ三世が終了しました。5秒後に再起動します...\n' "$(date -Iseconds)"
done
