const Module = require('module');
const { pathToFileURL } = require('url');
const os = require('os'), path = require('path'), fs = require('fs');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
fs.writeFileSync(path.join(dir, 'dep.js'), 'module.exports = 1;');
const url = pathToFileURL(path.join(dir, 'x.js')).href + '?a=1';
const base = pathToFileURL(dir).href;
Module.registerHooks({
  resolve(spec, context, next) {
    if (spec === './dep.js') {
      console.log('parentURL:', context.parentURL && context.parentURL.replace(base, '<dir>'));
    }
    return next(spec, context);
  },
});
const req = Module.createRequire(new URL(url));
req('./dep.js');
fs.rmSync(dir, { recursive: true });
