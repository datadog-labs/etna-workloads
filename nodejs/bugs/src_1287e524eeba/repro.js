'use strict';
// Run with --expose-gc via v8 flag set at runtime.
require('v8').setFlagsFromString('--expose-gc');
const gc = require('vm').runInNewContext('gc');
const { duplexPair } = require('stream');
const tls = require('tls');
const dummy = Buffer.alloc(10000, 'yolo');
let runs = 0, negative = false;
function connect() {
  if (runs % 64 === 0) gc();
  if (process.memoryUsage().external < 0) negative = true;
  if (runs++ === 512) {
    console.log('external went negative:', negative);
    return;
  }
  const [clientSide, serverSide] = duplexPair();
  const s = tls.connect({ socket: clientSide });
  s.on('error', connect);
  setImmediate(() => serverSide.write(dummy));
}
connect();
