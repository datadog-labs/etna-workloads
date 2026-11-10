'use strict';
const dgram = require('dgram');
process.on('uncaughtException', (e) => { console.log('uncaught:', e.code); });
const c = new AbortController();
const s = dgram.createSocket({ type: 'udp4', signal: c.signal });
s.close();
c.abort();
setTimeout(() => console.log('done'), 100);
