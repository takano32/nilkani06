# ニルカニちゃん六世

AI秘書っす。

## 使い方

- `claude` CLI（Claude Code）をインストールする
  - [claude.ai/code](https://claude.ai/code) の手順に従う

- Discord Bot を作る
  - [Discord Developer Portal](https://discord.com/developers/applications) で Application を作成
  - Bot を作成し、Bot Token を取得（`DISCORD_BOT_TOKEN` に設定）
  - Bot をサーバーに招待し、通知・会話に使うチャンネルの Channel ID を取得（`DISCORD_CHANNEL_ID` に設定）

- 環境変数を設定して boot.bash で起動する

```sh
DISCORD_BOT_TOKEN=... \
DISCORD_CHANNEL_ID=... \
./boot.bash
```

- あとは、死ぬほど会話とかする

- 終わり

## トラブルシューティング

- AIに聞け！俺には聞くな！！

## ライセンス

ニルカニちゃんライセンスに従うものとする。（まだない）

## 免責事項

家が燃えたとか、なんか起きても全て責任は負わないです。
