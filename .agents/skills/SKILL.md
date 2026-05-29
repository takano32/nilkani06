---
name: nilkani06-skills
description: Skills and work patterns for the Nilkani06 project (boot.bash + Claude Channels Discord)
---

# SKILL.md — ニルカニちゃん六世 エージェントスキル定義

このファイルは、Claude Code がこのリポジトリで作業する際に参照するスキル集。
ボット本体の能力拡張方法と、Claude Code 自身の作業パターンを記録する。

---

## 現在のアーキテクチャ

`boot.bash` が `claude --dangerously-skip-permissions --channels plugin:discord@claude-plugins-official -c` を実行する。Discord のメッセージ受信・返信は Claude Channels (`discord` プラグイン) が担う。`bot.js` は存在しない。

| コンポーネント | 役割 |
|---|---|
| `boot.bash` | 再起動ループ・Discord 起動通知 |
| `claude` CLI | Discord Channels 経由で会話を処理 |
| Discord Bot API | 通知送信（`notify_discord`） |

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
- `notify_discord` は `curl -s -X POST -H "Content-Type: application/json" -d '{"content":"..."}' "https://discord.com/api/v10/channels/${DISCORD_CHANNEL_ID}/messages"` の形式で送信する。

### Discord Bot のセットアップ手順

1. [Discord Developer Portal](https://discord.com/developers/applications) で Application を作成
2. Bot を作成し、Bot Token を取得 → `DISCORD_BOT_TOKEN` に設定
3. Bot をサーバーに招待（`Send Messages` 権限が必要）
4. 通知・会話先チャンネルの ID を取得 → `DISCORD_CHANNEL_ID` に設定

---

## プラットフォーム移行履歴

| バージョン | プラットフォーム | AI |
|---|---|---|
| 〜五世 | Telegram | Claude |
| 六世（初期） | Slack (Socket Mode) | OpenAI → Groq |
| 六世（中期） | Discord (Gateway) | OpenAI (ChatGPT) |
| 六世（Telegram 回帰） | Telegram (Claude Channels) | Claude Code |
| 六世（現在） | Discord (Claude Channels) | Claude Code |

---

## ディレクトリ構成

```
.agents/
  logs/      # Claude Code セッションログ（Markdown + JSON）
  skills/    # 本ファイル。スキル定義・作業パターン
```
