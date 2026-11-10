'use strict';
const { spawnSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const f = path.join(dir, 'a.test.mjs');
fs.writeFileSync(f, `import { before, describe, it } from 'node:test';
describe('todo suite', { todo: 'evaluating' }, () => {
  before(() => { throw new Error('simulated'); });
  it('child 1', () => {});
  it('child 2', () => {});
});
`);
const c = spawnSync(process.execPath, ['--test', '--test-reporter=tap', f], { cwd: dir });
const out = c.stdout.toString();
console.log('exit status:', c.status);
console.log(out.split('\n').filter((l) => /^# (fail|todo)/.test(l)).join('\n'));
fs.rmSync(dir, { recursive: true, force: true });
