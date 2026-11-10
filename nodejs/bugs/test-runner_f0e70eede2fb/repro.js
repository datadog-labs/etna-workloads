const { spawnSync } = require('child_process');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, ['--expose-internals', '--no-warnings', __filename, 'child'], { encoding: 'utf8' });
  console.log(r.stdout + r.stderr.split('\n').slice(0, 3).join('\n'));
  console.log('status', r.status);
  return;
}
const { DefaultSerializer } = require('v8');
const runner = require('internal/test_runner/runner');
const ser = require('internal/test_runner/reporter/v8-serializer');
(async () => {
  const chunks = [];
  for await (const c of ser([{ type: 'test:diagnostic', data: { nesting: 0, details: {}, message: 'diagnostic' } }])) chunks.push(c);
  const data = chunks[0];
  for (const i of [1, 2, 3, 4, 5, 6]) {
    const ft = new runner.FileTest({ name: 'filetest', harness: { config: {} } });
    const out = [];
    ft.reporter.on('data', (d) => out.push(d.type));
    try {
      ft.parseMessage(data.subarray(0, i));
      ft.parseMessage(data.subarray(i));
      ft.drain();
      ft.reporter.end();
      await require('stream/promises').finished(ft.reporter);
    } catch (e) { out.push('throw ' + e.message.split('\n')[0]); }
    console.log(i, JSON.stringify(out));
  }
})();
