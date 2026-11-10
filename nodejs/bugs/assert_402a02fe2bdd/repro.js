'use strict';
const { spawnSync } = require('child_process');
const code = `
const { myersDiff } = require('internal/assert/myers_diff');
try { myersDiff({ length: 2 ** 31 - 1 }, { length: 2 }); console.log('no error'); }
catch (e) { console.log(e.name, e.code); }
`;
const r = spawnSync(process.execPath, ['--expose-internals', '-e', code], { encoding: 'utf8', timeout: 5000 });
console.log('stdout:', r.stdout.trim());
console.log('threw-code-line:', /ERR_OUT_OF_RANGE/.test(r.stdout));
