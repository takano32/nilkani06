# SKILL.md — ニルカニちゃん六世 エージェントスキル定義

このファイルは、Claude Code がこのリポジトリで作業する際に参照するスキル集。
ボット本体の能力拡張方法と、Claude Code 自身の作業パターンを記録する。

---

## ボットスキル (bot.js)

### 現在実装済み

| スキル | 説明 |
|---|---|
| 会話継続 | チャンネルごとにセッション内の会話履歴を保持して Groq に渡す |
| セッション保存 | 発言のたびに `sessions/YYYY-MM-DD_HH-MM-SS.json` へ追記 |
| 再起動通知 | `boot.bash` が起動・再起動イベントを Slack に通知 |
| マルチチャンネル | 複数チャンネルを1プロセスで処理し、チャンネルごとに会話を分離 |

### 拡張パターン

#### システムプロンプトをカスタマイズする

`SYSTEM_PROMPT` 環境変数で上書き可能。起動時に設定するだけでよい。

```sh
SYSTEM_PROMPT="あなたはコードレビュー専門のAIです。" ./boot.bash
```

#### モデルを切り替える

`GROQ_MODEL` 環境変数で指定。デフォルトは `llama-3.3-70b-versatile`。

```sh
GROQ_MODEL=llama-3.1-8b-instant ./boot.bash   # より高速・軽量
GROQ_MODEL=mixtral-8x7b-32768 ./boot.bash     # コンテキスト長重視
```

#### コマンドを追加する (`bot.js`)

`app.message` ハンドラ内で `text` を見てコマンドとして処理できる。

```js
if (text.startsWith('/reset')) {
  sessions[channelId] = [];
  await say('会話履歴をリセットしました。');
  return;
}
```

---

## Claude Code 作業スキル

### ログを記録する

セッション終了後に `.agents/logs/YYYY-MM-DD_HH-MM-SS.md` と `.json` を作成する。
Markdown は人間向け（会話ログ・変更一覧・技術メモ）、JSON はツール向け（構造化データ）。

### ドキュメントを更新する順序

1. `CLAUDE.md` — 環境変数・起動方法・編集上の注意
2. `README.md` — セットアップ手順（ユーザー向け）
3. `.agents/skills/SKILL.md` — スキル定義（本ファイル）

### boot.bash を編集するときの制約

- `#!/usr/bin/env bash`、`set -euo pipefail` 必須。bash 4.0 以上の記法 (`[[`, `local`, 配列など) を積極的に使ってよい。
- 認証情報は環境変数経由のみ。スクリプト内のデフォルト値はダミー文字列にとどめる。
- Slack API 呼び出しは `--data-urlencode` を使った form-encoded 方式で JSON 組み立てを避ける。

### セッションファイルのスキーマを変えるときの注意

`bot.js` の `saveSession` と `allMessages` 配列の構造を同時に変更する。
既存の `sessions/*.json` との後方互換性は保証しなくてよい（人間が読む用途のため）。

---

## ディレクトリ構成

```
.agents/
  logs/      # Claude Code セッションログ（Markdown + JSON）
  skills/    # 本ファイル。スキル定義・作業パターン
sessions/    # ボットの会話ログ（.gitignore 済み）
```
