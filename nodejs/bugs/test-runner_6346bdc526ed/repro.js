'use strict';
const { before, after, test } = require('node:test');
const { createServer } = require('node:http');
let server;
before(() => new Promise((r) => { server = createServer(); server.listen(0, r); }));
after(() => { console.log('after ran'); server.close(); });
test('t', () => {});
process.stdout.write = ((w) => (s, ...a) => (String(s).startsWith('after') || String(s).startsWith('HANG') ? w.call(process.stdout, s, ...a) : true))(process.stdout.write);
setTimeout(() => { console.log('HANG: after() never ran, event loop kept alive'); process.exit(3); }, 3000).unref();
