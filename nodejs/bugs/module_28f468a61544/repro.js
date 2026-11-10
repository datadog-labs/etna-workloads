'use strict';
const fs = require('fs');
const os = require('os');
const path = require('path');
const { registerHooks } = require('module');
const { pathToFileURL } = require('url');

const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const f = path.join(dir, 'redirected-zlib.js');
fs.writeFileSync(f, "module.exports = { marker: 'redirected zlib' };");
const url = pathToFileURL(f).href;

registerHooks({
  resolve(specifier, context, nextResolve) {
    return { url, shortCircuit: true };
  },
});
try {
  console.log(require('node:zlib').marker);
} catch (e) {
  console.log('error:', e.code || e.message);
}
fs.rmSync(dir, { recursive: true, force: true });
