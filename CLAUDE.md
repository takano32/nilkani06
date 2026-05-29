# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

@.agents/AGENTS.md

## プロジェクト概要

「ニルカニちゃん六世」は、Slack Bot 経由で ChatGPT (OpenAI API) を常時稼働させるための極小ラッパー。`bot.js` が Slack の Socket Mode でメッセージを受信し、OpenAI API を呼んで返信する。`boot.sh` がクラッシュ時の再起動ループと Slack への起動通知を担当する。

## 起動方法

```sh
SLACK_BOT_TOKEN=xoxb-... \
SLACK_APP_TOKEN=xapp-... \
SLACK_NOTIFY_CHANNEL=C... \
OPENAI_API_KEY=sk-... \
./boot.sh
```

- `boot.sh` は `node bot.js` を無限ループで実行し、終了したら 5 秒待って再起動する。
- 初回起動と再起動の各イベントを Slack にプッシュ通知する (`notify_slack` 関数)。
- セッションファイルはプロセス起動ごとに `sessions/YYYY-MM-DD_HH-MM-SS.json` として生成される。

## 必須の前提

- Node.js が導入されていること。
- `npm install` で依存パッケージ (`@slack/bolt`, `openai`) をインストール済みであること。
- Slack App が Socket Mode で設定済みであること。Bot Token (`xoxb-...`) と App Token (`xapp-...`) を取得しておく。
- 環境変数 `SLACK_BOT_TOKEN` / `SLACK_APP_TOKEN` / `SLACK_NOTIFY_CHANNEL` / `OPENAI_API_KEY` を実際の値に置換する。

## 環境変数

| 変数名 | 説明 |
|---|---|
| `SLACK_BOT_TOKEN` | Slack Bot Token (`xoxb-...`) |
| `SLACK_APP_TOKEN` | Slack App-Level Token (`xapp-...`、Socket Mode 用) |
| `SLACK_NOTIFY_CHANNEL` | 起動通知を送るチャンネル ID |
| `OPENAI_API_KEY` | OpenAI API Key |
| `OPENAI_MODEL` | 使用モデル（省略時: `gpt-4o`） |
| `SYSTEM_PROMPT` | システムプロンプト（省略時: デフォルト文言） |

## 編集時の注意

- `boot.sh` は POSIX sh で書かれている (`#!/bin/sh`)。bash 固有構文を持ち込まないこと。
- 認証情報は boot.sh にハードコードせず、必ず環境変数経由で渡す前提を崩さない。
- `bot.js` はチャンネルごとに会話履歴を分離してコンテキストを構築している。セッションファイルには全チャンネルの発言が時系列で記録される。
