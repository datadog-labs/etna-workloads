'use strict';
const { fork } = require('child_process');
const fs = require('fs');
if (process.argv[2] === 'child') {
  fs.writeSync(process.channel.fd, Buffer.from([0x80, 0, 0, 1]));
  setTimeout(() => {}, 500);
  return;
}
process.on('uncaughtException', (e) => {
  console.log('uncaught:', e.constructor.name);
  process.exit(1);
});
const c = fork(__filename, ['child'], { serialization: 'advanced' });
c.on('message', (m) => console.log('message', m));
c.on('error', (e) => console.log('error:', e.constructor.name));
c.on('exit', (code, sig) => console.log('exit', code, sig));
