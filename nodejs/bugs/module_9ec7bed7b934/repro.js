const fs = require('fs'), os = require('os'), path = require('path');
const { registerHooks } = require('module');
const { pathToFileURL } = require('url');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const f = path.join(dir, 'redirected.js');
fs.writeFileSync(f, "exports.v = 'redirected';");
const hook = registerHooks({
  resolve: (s, c, next) => ({ url: 'foo://bar', shortCircuit: true }),
  load: (url, c, next) => next(pathToFileURL(f).href, c),
});
try { console.log(require('foo').v); } catch (e) { console.log('error', e.code); }
hook.deregister();
fs.rmSync(dir, { recursive: true });
