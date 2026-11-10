'use strict';
const { spawnSync } = require('child_process');
const code = `
const { internalBinding } = require('internal/test/binding');
const b = internalBinding('performance');
b.uvMetricsInfo();
console.log('buffer type:', b.uvMetricsBuffer.constructor.name);
console.log('bytes per element:', b.uvMetricsBuffer.BYTES_PER_ELEMENT);
`;
const r = spawnSync(process.execPath, ['--no-warnings', '--expose-internals', '-e', code], { encoding: 'utf8' });
process.stdout.write(r.stdout + r.stderr);
process.exitCode = r.status;
