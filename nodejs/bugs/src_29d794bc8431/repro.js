'use strict';
const { spawnSync } = require('child_process');
if (!process.argv.includes('--child')) {
  const r = spawnSync(process.execPath, ['--no-warnings', '--expose-internals', __filename, '--child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout); process.stderr.write(r.stderr);
  process.exit(r.status);
}
const { internalBinding } = require('internal/test/binding');
const { buildEmbedderGraph } = internalBinding('heap_utils');
const first = {}, second = {};
const big = BigInt('123456789012345678901234567890');
const big2 = BigInt('123456789012345678901234567890');
const graph = buildEmbedderGraph(first, first, second, big, big2);
const count = (v) => graph.filter((n) => Object.hasOwn(n, 'value') && Object.is(n.value, v)).length;
console.log(count(first), count(second), count(big));
