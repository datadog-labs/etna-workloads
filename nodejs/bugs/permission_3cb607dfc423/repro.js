'use strict';
const { spawnSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');

if (process.argv[2] === 'child') {
  const t = require('trace_events').createTracing({ categories: ['node', 'v8'] });
  try {
    t.enable();
    console.log('enabled without error');
  } catch (e) {
    console.log('error:', e.code);
  }
  process.exit(0);
}
const base = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const allowed = path.join(base, 'allowed');
const outside = path.join(base, 'outside');
fs.mkdirSync(allowed); fs.mkdirSync(outside);
const r = spawnSync(process.execPath, ['--permission', '--allow-fs-read=*',
  `--allow-fs-write=${allowed}`, __filename, 'child'], { cwd: outside, encoding: 'utf8' });
console.log(r.stdout.trim());
console.log('trace file created outside:', fs.readdirSync(outside).length > 0);
console.log('status', r.status);
fs.rmSync(base, { recursive: true, force: true });
