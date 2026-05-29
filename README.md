# ニルカニちゃん六世

AI秘書っす。

## 使い方

- OpenAI API Key を取得する
  - [platform.openai.com](https://platform.openai.com) でアカウント作成 → API Keys → Create new secret key

- Discord アプリを作る（discord.com/developers/applications）
  - Bot を作成 → **Message Content Intent** を有効化（Privileged Gateway Intents）
  - Bot Token を取得
  - 通知用 Webhook URL を取得（省略可）
  - Bot をサーバーに招待（`bot` + `applications.commands` スコープ、`Send Messages` / `Read Message History` 権限）

- 依存パッケージをインストールする

```sh
npm install
```

- 環境変数を設定して boot.bash で起動する

```sh
DISCORD_TOKEN=... \
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/... \
OPENAI_API_KEY=sk-... \
./boot.bash
```

- あとは、死ぬほど会話とかする

- 終わり

## セッションログ

会話は `sessions/YYYY-MM-DD_HH-MM-SS.json` に自動保存される。Bot 起動ごとに新しいファイルが作られる。

## トラブルシューティング

- AIに聞け！俺には聞くな！！

## ライセンス

ニルカニちゃんライセンスに従うものとする。（まだない）

## 免責事項

家が燃えたとか、なんか起きても全て責任は負わないです。
