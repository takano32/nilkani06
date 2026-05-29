'use strict';

const { App } = require('@slack/bolt');
const OpenAI = require('openai');
const fs = require('fs');
const path = require('path');

const SESSIONS_DIR = path.join(__dirname, 'sessions');
const MODEL = process.env.GROQ_MODEL || 'llama-3.3-70b-versatile';
const SYSTEM_PROMPT = process.env.SYSTEM_PROMPT || 'あなたは親切で有能なAIアシスタントです。';

const app = new App({
  token: process.env.SLACK_BOT_TOKEN,
  appToken: process.env.SLACK_APP_TOKEN,
  socketMode: true,
});

const openai = new OpenAI({
  apiKey: process.env.GROQ_API_KEY,
  baseURL: 'https://api.groq.com/openai/v1',
});

// セッションファイルをプロセス起動時に作成
if (!fs.existsSync(SESSIONS_DIR)) fs.mkdirSync(SESSIONS_DIR, { recursive: true });

const sessionStart = new Date();
const pad = n => String(n).padStart(2, '0');
const sessionFilename = [
  sessionStart.getFullYear(),
  pad(sessionStart.getMonth() + 1),
  pad(sessionStart.getDate()),
].join('-') + '_' + [
  pad(sessionStart.getHours()),
  pad(sessionStart.getMinutes()),
  pad(sessionStart.getSeconds()),
].join('-') + '.json';
const sessionFile = path.join(SESSIONS_DIR, sessionFilename);

// { timestamp, channel, role, content }[]
let allMessages = [];

function saveSession() {
  fs.writeFileSync(sessionFile, JSON.stringify({
    session_start: sessionStart.toISOString(),
    messages: allMessages,
  }, null, 2), 'utf8');
}

saveSession();

app.message(async ({ message, say }) => {
  if (message.subtype || message.bot_id) return;

  const text = message.text || '';
  const channelId = message.channel;

  allMessages.push({ timestamp: new Date().toISOString(), channel: channelId, role: 'user', content: text });
  saveSession();

  // チャンネルごとの会話履歴を OpenAI に渡す
  const channelHistory = allMessages
    .filter(m => m.channel === channelId)
    .map(m => ({ role: m.role, content: m.content }));

  let reply;
  try {
    const completion = await openai.chat.completions.create({
      model: MODEL,
      messages: [{ role: 'system', content: SYSTEM_PROMPT }, ...channelHistory],
    });
    reply = completion.choices[0].message.content;
  } catch (err) {
    reply = `エラーが発生しました: ${err.message}`;
    console.error(err);
  }

  allMessages.push({ timestamp: new Date().toISOString(), channel: channelId, role: 'assistant', content: reply });
  saveSession();

  await say(reply);
});

(async () => {
  await app.start();
  console.log(`起動完了: sessions/${sessionFilename}`);
})();
