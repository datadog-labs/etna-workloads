'use strict';
const { spawn } = require('node:child_process');
const child = spawn(process.execPath, ['--inspect-wait=0', '-e', "console.log('test');"]);
let done = false;
let buf = '';
child.stderr.on('data', (d) => {
  buf += d;
  const m = buf.match(/ws:\/\/127\.0\.0\.1:\d+\/[a-f0-9-]+/);
  if (m && !done) {
    done = true;
    const socket = new WebSocket(m[0]);
    socket.addEventListener('open', () => socket.send('This is not a valid protocol message'));
    socket.addEventListener('message', (e) => {
      console.log('response has error:', 'error' in JSON.parse(e.data));
      socket.close();
      child.kill();
    });
  }
});
child.on('exit', (code, signal) => {
  console.log('child exit:', signal);
  setTimeout(() => process.exit(0), 50);
});
setTimeout(() => { console.log('timeout'); child.kill('SIGKILL'); }, 15000).unref();
