# ニルカニちゃん六世

AI秘書っす。

## 使い方

- Groq API Key を取得する（無料枠あり）
  - [console.groq.com](https://console.groq.com) でアカウント作成 → API Keys → Create API Key

- Slack App を作る（api.slack.com/apps）
  - Socket Mode を有効化 → App-Level Token (`xapp-...`) を取得
  - Bot Token Scopes: `chat:write` / `channels:history` / `groups:history` / `im:history` / `im:write`
  - Event Subscriptions: `message.channels` / `message.im` を Subscribe
  - Bot Token (`xoxb-...`) を取得

- 依存パッケージをインストールする

```sh
npm install
```

- 環境変数を設定して boot.bash で起動する

```sh
SLACK_BOT_TOKEN=xoxb-... \
SLACK_APP_TOKEN=xapp-... \
SLACK_NOTIFY_CHANNEL=C... \
GROQ_API_KEY=gsk_... \
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
