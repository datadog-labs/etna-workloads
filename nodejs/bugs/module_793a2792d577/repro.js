const fs = require('fs'), os = require('os'), path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
const mk = (n) => { const f = path.join(d, n); fs.writeFileSync(f, "throw new Error('test');\nexport {};\n"); return f; };
const a = mk('a.mjs'), b = mk('b.mjs');
const tryReq = (f) => { try { require(f); return 'no throw'; } catch (e) { return 'threw: ' + e.message; } };
(async () => {
  try { await import(a); console.log('import1 resolved'); } catch (e) { console.log('import1 rejected: ' + e.message); }
  console.log('require after import:', tryReq(a));
  console.log('require first:', tryReq(b));
  try { await import(b); console.log('import after require resolved'); } catch (e) { console.log('import after require rejected: ' + e.message); }
  fs.rmSync(d, { recursive: true, force: true });
})();
