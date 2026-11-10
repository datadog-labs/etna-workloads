'use strict';
const http = require('http');
const stream = require('stream');
const expected = ['a', 'b', '', Buffer.alloc(0), 'c'];
const results = [];
const writable = new stream.Writable({ write(c, e, cb) { cb(); } });
const res = new http.ServerResponse({ method: 'GET', httpVersionMajor: 1, httpVersionMinor: 1 });
res.assignSocket(writable);
for (const chunk of expected) res.write(chunk, () => results.push(chunk.length));
res.end(() => {
  console.log('callbacks:', results.join(','));
});
