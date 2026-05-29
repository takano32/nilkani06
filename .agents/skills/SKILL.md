---
name: nilkani06-skills
description: Skills and work patterns for the Nilkani06 project (boot.bash + Claude Channels Telegram)
---

# SKILL.md — ニルカニちゃん六世 エージェントスキル定義

このファイルは、Claude Code がこのリポジトリで作業する際に参照するスキル集。
ボット本体の能力拡張方法と、Claude Code 自身の作業パターンを記録する。

---

## 現在のアーキテクチャ

`boot.bash` が `claude --dangerously-skip-permissions --channels plugin:telegram@claude-plugins-official -c` を実行する。Telegram のメッセージ受信・返信は Claude Channels (`telegram` プラグイン) が担う。`bot.js` は存在しない。

| コンポーネント | 役割 |
|---|---|
| `boot.bash` | 再起動ループ・Telegram 起動通知 |
| `claude` CLI | Telegram Channels 経由で会話を処理 |
| Telegram Bot API | 通知送信（`notify_telegram`） |

---

## Claude Code 作業スキル

### ログを記録する

セッション終了後に以下を行う。

1. `.agents/logs/YYYY-MM-DD_HH-MM-SS.md` と `.json` を作成（詳細ログ）

Markdown ログは人間向け（会話ログ・変更一覧・技術メモ）、JSON はツール向け（構造化データ）。

### ドキュメントを更新する順序

1. `CLAUDE.md` — 環境変数・起動方法・編集上の注意
2. `README.md` — セットアップ手順（ユーザー向け）
3. `.agents/skills/SKILL.md` — スキル定義（本ファイル）
4. `.env.example` — 環境変数テンプレート

### boot.bash を編集するときの制約

- `#!/usr/bin/env bash`、`set -uo pipefail` 必須。bash 5.0 以上の記法 (`[[`, `local`, `declare -i`, `(( ))` など) を積極的に使ってよい。
- 認証情報は環境変数経由のみ。スクリプト内のデフォルト値はダミー文字列にとどめる。
- `notify_telegram` は `curl --data-urlencode` で Telegram Bot API の `sendMessage` に送信する。

### Telegram Bot のセットアップ手順

1. `@BotFather` に `/newbot` → Token 取得 → `TELEGRAM_BOT_TOKEN` に設定
2. Bot との会話を開始し、`https://api.telegram.org/bot<TOKEN>/getUpdates` で Chat ID を取得
3. Chat ID を `TELEGRAM_CHAT_ID` に設定

---

## プラットフォーム移行履歴

| バージョン | プラットフォーム | AI |
|---|---|---|
| 〜五世 | Telegram | Claude |
| 六世（初期） | Slack (Socket Mode) | OpenAI → Groq |
| 六世（中期） | Discord (Gateway) | OpenAI (ChatGPT) |
| 六世（現在） | Telegram (Claude Channels) | Claude Code |

---

## ディレクトリ構成

```
.agents/
  logs/      # Claude Code セッションログ（Markdown + JSON）
  skills/    # 本ファイル。スキル定義・作業パターン
```
