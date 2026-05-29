'use strict';

const { Client, GatewayIntentBits, Partials } = require('discord.js');
const OpenAI = require('openai');
const fs = require('fs');
const path = require('path');

const SESSIONS_DIR = path.join(__dirname, 'sessions');
const MODEL = process.env.GROQ_MODEL || 'llama-3.3-70b-versatile';
const SYSTEM_PROMPT = process.env.SYSTEM_PROMPT || 'あなたは親切で有能なAIアシスタントです。';
const MAX_HISTORY = parseInt(process.env.MAX_HISTORY || '50', 10);

const client = new Client({
  intents: [
    GatewayIntentBits.Guilds,
    GatewayIntentBits.GuildMessages,
    GatewayIntentBits.MessageContent,
    GatewayIntentBits.DirectMessages,
  ],
  partials: [Partials.Channel],
});

const openai = new OpenAI({
  apiKey: process.env.GROQ_API_KEY,
  baseURL: 'https://api.groq.com/openai/v1',
});

if (!fs.existsSync(SESSIONS_DIR)) fs.mkdirSync(SESSIONS_DIR, { recursive: true });

function loadPastSessions(currentFile) {
  return fs.readdirSync(SESSIONS_DIR)
    .filter(f => f.endsWith('.json') && f !== currentFile)
    .sort()
    .flatMap(f => {
      try {
        const data = JSON.parse(fs.readFileSync(path.join(SESSIONS_DIR, f), 'utf8'));
        return Array.isArray(data.messages) ? data.messages : [];
      } catch (_) { return []; }
    });
}

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

// 過去セッション（読み取り専用）と現セッション（保存対象）を分離
const pastMessages = loadPastSessions(sessionFilename);
let allMessages = [];

function saveSession() {
  fs.writeFileSync(sessionFile, JSON.stringify({
    session_start: sessionStart.toISOString(),
    messages: allMessages,
  }, null, 2), 'utf8');
}

saveSession();

client.on('messageCreate', async (message) => {
  if (message.author.bot) return;

  const text = message.content || '';
  const channelId = message.channelId;

  allMessages.push({ timestamp: new Date().toISOString(), channel: channelId, role: 'user', content: text });
  saveSession();

  const channelHistory = [...pastMessages, ...allMessages]
    .filter(m => m.channel === channelId)
    .slice(-MAX_HISTORY)
    .map(({ role, content }) => ({ role, content }));

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

  await message.reply(reply);
});

client.once('ready', () => {
  console.log(`起動完了: ${client.user.tag} sessions/${sessionFilename}`);
});

client.login(process.env.DISCORD_TOKEN);
