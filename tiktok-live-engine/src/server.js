const WebSocket = require('ws');
const tiktok = require('./tiktokClient');
const bus = require('./messageBus');
const { validateUsername } = require('./guards');
const log = require('./logger');

function startServer(port = 8899) {
  const wss = new WebSocket.Server({ port });

  log.info(`Live engine listening on ws://127.0.0.1:${port}`);

  wss.on('connection', ws => {
    bus.attach(ws);
    log.info('Client connected');

    ws.on('message', async msg => {
      try {
        const data = JSON.parse(msg);

        if (data.action === 'start') {
          if (!validateUsername(data.username)) {
            ws.send(JSON.stringify({ type: 'error', message: 'Invalid username' }));
            return;
          }
          await tiktok.start(data.username);
        }

        if (data.action === 'stop') {
          tiktok.stop();
        }
      } catch (e) {
        log.error(e.message);
      }
    });

    ws.on('close', () => {
      log.info('Client disconnected');
      tiktok.stop();
      bus.detach();
    });
  });
}

module.exports = { startServer };
