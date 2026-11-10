const { pipeline, Duplex, PassThrough } = require('stream');
const remote = new PassThrough();
const local = new Duplex({ read() {}, write(c, e, cb) { cb(); } });
pipeline(remote, local, remote, (err) => {
  console.log('pipeline done:', err && err.code);
  process.exit(0);
});
setImmediate(() => remote.end());
setTimeout(() => { console.log('timeout: pipeline never finished'); process.exit(1); }, 1000);
