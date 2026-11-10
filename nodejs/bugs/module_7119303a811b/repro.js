const fs = require('fs'), os = require('os'), path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'rr-'));
fs.mkdirSync(path.join(d, 'a/b'), { recursive: true });
fs.writeFileSync(path.join(d, 'a/index.js'), '');
fs.writeFileSync(path.join(d, 'a/b/index.js'), '');
const rel = (p) => path.relative(d, p);
for (const [req, base] of [['.', 'a'], ['..', 'a/b']]) {
  try {
    console.log(req, rel(require.resolve(req, { paths: [path.join(d, base)] })));
  } catch (e) { console.log(req, e.code); }
}
fs.rmSync(d, { recursive: true, force: true });
