const { TikTokLiveConnection, WebcastEvent, ControlEvent } = require('tiktok-live-connector');
const bus = require('./messageBus');
const log = require('./logger');

let connection = null;

async function start(username) {
    
    if (connection) return;

    connection = new TikTokLiveConnection(username);

    // Share event
    connection.on(WebcastEvent.SHARE, (data) => {
        console.log(`[${data.user.userId}] ${data.user.nickname} shared the stream!`);
        //console.log(JSON.stringify(data, null, 2));
        bus.send({
            type: 'SHARE',
            userId: data.user.userId,
            text: data.user.nickname,
            time: Date.now()
        });
    });

    // Comment event
    connection.on(WebcastEvent.CHAT, data => {
        console.log(`[${data.user.userId}] ${data.user.nickname} -> ${data.comment}`);
        //console.log(JSON.stringify(data, null, 2));
        bus.send({
            type: 'COMMENT',
            userId: data.user.userId,
            nickname: data.user.nickname,
            comment: data.comment,
            time: Date.now()
        });
    });

    // Like event
    connection.on(WebcastEvent.LIKE, data => {
        console.log(`[${data.user.userId}] ${data.user.nickname} sent ${data.likeCount} likes, total likes: ${data.totalLikeCount}`);
        //console.log(JSON.stringify(data, null, 2));
        bus.send({
            type: 'LIKE',
            userId: data.user.userId,
            nickname: data.user.nickname,
            likeCount: data.likeCount,
            totalLikeCount: data.totalLikeCount,
            time: Date.now()
        });
    });
    
    // Disconnected event
    connection.on(ControlEvent.DISCONNECTED, () => {
        log.warn('TikTok live disconnected');
        stop();
    });

    await connection.connect().then(state => {
        console.info(`Connected to roomId ${state.roomId}`);
    }).catch(err => {
        console.error('Failed to connect', err);
    });
}

function stop() {
  if (connection) {
    connection.disconnect();
    connection = null;
    log.info('Live stopped');
  }
}

module.exports = { start, stop };
