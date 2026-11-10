if (process.argv[2] !== 'child') {
  const r = require('child_process').spawnSync(process.execPath,
    ['--experimental-bench', '--no-warnings', __filename, 'child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout + r.stderr);
  process.exit(r.status);
}
const { createRunner } = require('node:bench');
const r = createRunner({ yieldBetweenSamples: false });
r.bench('x', { samples: 2 }, (b) => b.record({ __proto__: null, operations: 1, duration_ns: 1n }));
const s = r.run({ warmup: 0 });
console.log(typeof s.map, typeof s.filter, typeof s.toArray);
