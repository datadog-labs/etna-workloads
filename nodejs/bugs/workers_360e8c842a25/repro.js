'use strict';
const { execFileSync } = require('child_process');
const fs = require('fs'), os = require('os'), path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const pre = path.join(dir, 'pre.js');
fs.writeFileSync(pre, `
const { Worker, threadId } = require('worker_threads');
if (threadId < 2) {
  const w = new Worker('1 + 1', { eval: true });
  w.on('error', (e) => console.log('error', threadId, e.name));
}
`);
try {
  const out = execFileSync(process.execPath, ['-r', pre, '-pe', '1+1'], { encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] });
  console.log('ok', JSON.stringify(out));
} catch (e) { console.log('fail', e.status, JSON.stringify(String(e.stderr).split('\n').filter(l=>/Error|ERR_/.test(l)).slice(0,2))); }
fs.rmSync(dir, { recursive: true });
