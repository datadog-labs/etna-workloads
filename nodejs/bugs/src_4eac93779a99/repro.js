'use strict';
if (!process.argv.includes('child')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--async-context-frame', '--expose-gc', '--expose-internals', __filename, 'child'], { stdio: 'inherit' });
  process.exit(r.status);
}
const { AsyncLocalStorage } = require('async_hooks');
const { freeParser, parsers, HTTPParser } = require('_http_common');
let collected = false;
const reg = new FinalizationRegistry(() => { collected = true; });
const als = new AsyncLocalStorage();
(function() {
  const store = {};
  reg.register(store, 1);
  let parser;
  als.run(store, () => {
    parser = parsers.alloc();
    parser.initialize(HTTPParser.RESPONSE, {});
  });
  freeParser(parser);
})();
global.gc();
setImmediate(() => { console.log('store collected:', collected); });
