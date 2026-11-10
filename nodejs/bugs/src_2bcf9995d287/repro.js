'use strict';
const { spawn } = require('child_process');
const fs = require('fs'), os = require('os'), path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const main = path.join(dir, 'main.mjs');
fs.writeFileSync(main, `
import { register } from 'node:module';
register('data:text/javascript,export async function resolve(s,c,n){return n(s,c)}');
await import('data:text/javascript,console.log("child: module loaded")');
console.log("child: done");
`);
const child = spawn(process.execPath, ['--inspect-wait=0', main], { stdio: ['ignore', 'pipe', 'pipe'] });
let out = '', err = '', connected = false, ws;
child.stdout.on('data', (d) => { out += d; if (out.includes('child: done') && ws) ws.close(); });
child.stderr.on('data', (d) => {
  err += d;
  const m = /ws:\/\/\S+/.exec(err);
  if (m && !connected) {
    connected = true;
    ws = new WebSocket(m[0]);
    ws.onopen = () => ws.send(JSON.stringify({ id: 1, method: 'Runtime.runIfWaitingForDebugger' }));
    ws.onerror = () => {};
  }
});
let timedOut = false;
const t = setTimeout(() => { timedOut = true; child.kill('SIGKILL'); }, 8000);
child.on('close', (code) => {
  clearTimeout(t);
  fs.rmSync(dir, { recursive: true, force: true });
  console.log(out.trim());
  console.log(timedOut ? 'RESULT: hung (loader worker blocked on inspector)' : `RESULT: exited code=${code}`);
});
