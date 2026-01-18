# Tiktok Live Engine

Cấu trúc thư mục

```pgsql
live-engine/
├─ src/
│  ├─ server.js          # WebSocket server
│  ├─ tiktokClient.js    # TikTok live wrapper
│  ├─ messageBus.js      # Gửi event về UI
│  ├─ guards.js          # Safety checks
│  └─ logger.js          # Log gọn
├─ index.js              # Entry point
├─ package.json
└─ README.md
```

Test nhanh:

```bash
npm install -g wscat
wscat -c ws://127.0.0.1:8899
```

```json
{"action":"start","username":"ngoclinh.pnl"}
{"action":"stop","username":"ngoclinh.pnl"}
```