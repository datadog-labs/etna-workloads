'use strict';
const { fork } = require('child_process');
const v8 = require('v8');
const fs = require('fs');
if (process.argv[2] === 'child') {
  const payload = v8.serialize({ hello: 'world' });
  const frame = Buffer.alloc(4 + payload.length);
  frame.writeUInt32BE(payload.length, 0);
  payload.copy(frame, 4);
  const fd = 3;
  fs.writeSync(fd, frame.subarray(0, 2));
  setTimeout(() => {
    fs.writeSync(fd, frame.subarray(2));
    setTimeout(() => process.disconnect(), 200);
  }, 200);
} else {
  const c = fork(__filename, ['child'], { serialization: 'advanced' });
  c.on('message', (m) => console.log('got', JSON.stringify(m)));
  c.on('exit', () => console.log('exit'));
  setTimeout(() => { c.kill(); }, 5000).unref();
}
