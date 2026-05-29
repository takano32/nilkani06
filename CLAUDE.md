# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

@.agents/AGENTS.md

## プロジェクト概要

「ニルカニちゃん六世」は、Discord 経由で Claude Code を常時稼働させるための極小ラッパー。`boot.bash` が Claude Code を `--channels plugin:discord@claude-plugins-official` オプション付きで起動し、クラッシュ時の再起動ループと Discord Bot API への起動通知を担当する。`bot.js` は存在しない（旧 Discord+OpenAI 実装は削除済み）。

## 起動方法

```sh
DISCORD_BOT_TOKEN=... \
DISCORD_CHANNEL_ID=... \
./boot.bash
```

- `boot.bash` は `claude --dangerously-skip-permissions --channels plugin:discord@claude-plugins-official -c` を無限ループで実行し、終了したら 5 秒待って再起動する。
- 初回起動と再起動の各イベントを Discord Bot API にプッシュ通知する (`notify_discord` 関数)。

## 必須の前提

- `claude` CLI（Claude Code）が導入されていること。
- Discord で Bot を作成し、Bot Token を取得済みであること。
- 通知・会話に使うチャンネルの Channel ID を取得済みであること。
- `claude-plugins-official` の `discord` プラグインが利用可能な状態であること。
- 環境変数 `DISCORD_BOT_TOKEN` / `DISCORD_CHANNEL_ID` を実際の値に置換する。

## 環境変数

| 変数名 | 説明 |
|---|---|
| `DISCORD_BOT_TOKEN` | Discord Bot Token（Developer Portal から取得） |
| `DISCORD_CHANNEL_ID` | 通知・会話先のチャンネル ID |

## デプロイ先

- **GCP e2-micro** / プロジェクト: `takano32` / ゾーン: `us-central1-a` / Debian 13
- **サービス管理**: systemd (`nilkani06.service`)、`EnvironmentFile=~/nilkani06/.env`
- **更新手順**:
  ```sh
  gcloud compute ssh e2-micro --zone=us-central1-a --project=takano32 --ssh-flag="-A" \
    --command="cd ~/nilkani06 && git pull && sudo systemctl restart nilkani06"
  ```
- **シークレット管理**: `.env` はローカルで作成し `gcloud compute scp` で転送すること（チャットに値を貼らない）

## 編集時の注意

- `boot.bash` は `#!/usr/bin/env bash` で書かれている。bash 5.0 以上の記法 (`[[`, `local`, `declare -i`, `(( ))` など) を使ってよい。
- 認証情報は boot.bash にハードコードせず、必ず環境変数経由で渡す前提を崩さない。スクリプト内のデフォルト値はダミー文字列にとどめる。
- `notify_discord` は `curl` で Discord Bot API の `channels/{id}/messages` エンドポイントに JSON POST する。`-d` と `Content-Type: application/json` を使うこと。
- Node.js / npm は不要。依存パッケージは存在しない。
