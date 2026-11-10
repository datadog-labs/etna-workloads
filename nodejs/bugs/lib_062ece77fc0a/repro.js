'use strict';
const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const preload = path.join(dir, 'delayed-ack.cjs');
const entry = path.join(dir, 'records.mjs');
fs.writeFileSync(preload, `
const childProcess = require('child_process');
const { spawn } = childProcess;
childProcess.spawn = (...args) => {
  const child = spawn(...args);
  const { send } = child;
  child.send = function(message, handle, options, callback) {
    if (message?.type === 'node:bench:ack') {
      const onComplete = () => {
        child.removeListener('message', onComplete);
        child.removeListener('close', onComplete);
        callback(null);
      };
      child.once('message', onComplete);
      child.once('close', onComplete);
      return send.call(this, message, handle, options, (error) => {
        if (error) { child.removeListener('message', onComplete); child.removeListener('close', onComplete); callback(error); }
      });
    }
    return send.call(this, message, handle, options, callback);
  };
  return child;
};
`);
fs.writeFileSync(entry, `
const pending = new Map();
process.on('message', (m) => {
  if (m?.type !== 'node:bench:ack') return;
  pending.get(m.id)?.(); pending.delete(m.id);
});
const t = setTimeout(() => { throw new Error('not acknowledged'); }, 10000);
function send(id) {
  return new Promise((resolve, reject) => {
    pending.set(id, resolve);
    process.send({ id, type: 'node:bench:record', record: { type: 'bench:diagnostic', data: {
      runId: process.env.NODE_BENCH_RUN_ID, fileRunId: process.env.NODE_BENCH_FILE_RUN_ID,
      entryFile: process.argv[1], message: 'acknowledged ' + id, level: 'info', file: process.argv[1] } } },
      (e) => { if (e) reject(e); });
  });
}
for (let i = 0; i < 32; i++) await send(10000 + i);
clearTimeout(t);
`);
const r = spawnSync(process.execPath, ['--no-warnings', '--experimental-bench', '--bench',
  '--require', preload, '--bench-reporter=json', entry], { encoding: 'utf8', timeout: 25000 });
const recs = r.stdout.trim().split('\n').filter(Boolean).map((l) => { try { return JSON.parse(l); } catch { return {}; } });
console.log('status', r.status);
console.log('diagnostics', recs.filter((x) => x.type === 'bench:diagnostic').length);
console.log('success', recs.at(-1)?.data?.success);
fs.rmSync(dir, { recursive: true, force: true });
