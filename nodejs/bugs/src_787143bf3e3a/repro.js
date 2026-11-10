'use strict';
const { executionAsyncResource, executionAsyncId, createHook } = require('async_hooks');
const http = require('http');
const hooked = {};
createHook({ init(id, type, trig, resource) { hooked[id] = resource; } }).enable();
const server = http.createServer((req, res) => {
  res.end('hi');
});
const results = {};
const check = (n) => { results[n] = executionAsyncResource() === hooked[executionAsyncId()]; };
server.listen(0, () => {
  check('listen');
  http.get({ port: server.address().port }, (res) => {
    check('response');
    res.on('data', () => check('data'));
    res.on('end', () => {
      check('end');
      server.close();
      console.log(JSON.stringify(results));
    });
  });
});
