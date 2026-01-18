let client = null;

function attach(ws) {
  client = ws;
}

function send(payload) {
  if (client && client.readyState === 1) {
    client.send(JSON.stringify(payload));
  }
}

function detach() {
  client = null;
}

module.exports = { attach, send, detach };
