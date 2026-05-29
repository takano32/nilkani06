# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

@.agents/AGENTS.md

## プロジェクト概要

「ニルカニちゃん六世」は、Discord Bot 経由で Groq API (Llama) を常時稼働させるための極小ラッパー。`bot.js` が Discord Gateway でメッセージを受信し、Groq API を呼んで返信する。`boot.bash` がクラッシュ時の再起動ループと Discord Webhook への起動通知を担当する。

## 起動方法

```sh
DISCORD_TOKEN=... \
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/... \
GROQ_API_KEY=gsk_... \
./boot.bash
```

- `boot.bash` は `node bot.js` を無限ループで実行し、終了したら 5 秒待って再起動する。
- 初回起動と再起動の各イベントを Discord Webhook にプッシュ通知する (`notify_discord` 関数)。
- セッションファイルはプロセス起動ごとに `sessions/YYYY-MM-DD_HH-MM-SS.json` として生成される。

## 必須の前提

- Node.js が導入されていること。
- `npm install` で依存パッケージ (`discord.js`, `openai`) をインストール済みであること。
- Discord Developer Portal でアプリケーション・Bot を作成し、以下を有効化しておく。
  - **Message Content Intent**（Privileged Gateway Intents）
  - **Server Members Intent**（任意）
- Bot をサーバーに招待する際は `bot` + `applications.commands` スコープと `Send Messages` / `Read Message History` 権限を付与する。
- 環境変数 `DISCORD_TOKEN` / `DISCORD_WEBHOOK_URL` / `GROQ_API_KEY` を実際の値に置換する。

## 環境変数

| 変数名 | 説明 |
|---|---|
| `DISCORD_TOKEN` | Discord Bot Token |
| `DISCORD_WEBHOOK_URL` | 起動通知を送る Webhook URL（省略可） |
| `GROQ_API_KEY` | Groq API Key (`gsk_...`) |
| `GROQ_MODEL` | 使用モデル（省略時: `llama-3.3-70b-versatile`） |
| `SYSTEM_PROMPT` | システムプロンプト（省略時: デフォルト文言） |
| `MAX_HISTORY` | LLM に渡すチャンネルごとの最大メッセージ数（省略時: `50`） |

## デプロイ先

- **GCP e2-micro** / プロジェクト: `takano32` / ゾーン: `us-central1-a` / Debian 13
- **サービス管理**: systemd (`nilkani06.service`)、`EnvironmentFile=~/nilkani06/.env`
- **更新手順**:
  ```sh
  gcloud compute ssh e2-micro --zone=us-central1-a --project=takano32 --ssh-flag="-A" \
    --command="cd ~/nilkani06 && git pull && npm install && sudo systemctl restart nilkani06"
  ```
- **シークレット管理**: `.env` はローカルで作成し `gcloud compute scp` で転送すること（チャットに値を貼らない）

## 編集時の注意

- `boot.bash` は `#!/usr/bin/env bash` で書かれている。bash 4.0 以上の記法 (`[[`, `local`, `set -euo pipefail` など) を使ってよい。
- 認証情報は boot.bash にハードコードせず、必ず環境変数経由で渡す前提を崩さない。
- `bot.js` はチャンネルごとに会話履歴を分離してコンテキストを構築している。セッションファイルには全チャンネルの発言が時系列で記録される。
- Bot はすべてのメッセージ（Bot 自身を除く）に返信する。DM にも応答する（`Partials.Channel` により対応）。
