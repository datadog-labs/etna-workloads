const fs = require('fs');
const os = require('os');
const path = require('path');
const { pathToFileURL } = require('url');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const f = path.join(dir, 'data.json');
fs.writeFileSync(f, '{"v":1}');
const url = pathToFileURL(f).href;
(async () => {
  const a = await import(url + '?q=1', { with: { type: 'json' } });
  fs.writeFileSync(f, '{"v":2}');
  const b = await import(url + '?q=2', { with: { type: 'json' } });
  console.log('first', a.default.v, 'second', b.default.v);
  console.log('distinct', a.default !== b.default);
  console.log('require-cache-polluted', f in require.cache);
  fs.rmSync(dir, { recursive: true, force: true });
})();
