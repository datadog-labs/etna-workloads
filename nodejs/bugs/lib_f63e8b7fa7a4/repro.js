const http = require('http');
const cases = [
  ['socketPath+path', { path: '/x', socketPath: '/sock' }],
  ['socketPath only', { socketPath: '/sock' }],
  ['port+path', { path: '/x', port: 1 }],
  ['port only', { port: 1 }],
];
let i = 0;
(function next() {
  if (i === cases.length) return;
  const [name, o] = cases[i++];
  const req = http.get({ ...o, createConnection(opts, cb) {
    console.log(name, '-> opts.path =', opts.path);
    cb(new Error('stop'));
  } });
  req.on('error', () => next());
})();
