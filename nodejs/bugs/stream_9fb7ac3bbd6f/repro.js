const { pipeline, Duplex, PassThrough } = require('stream');
const a = new PassThrough();
a.end('foobar');
const b = new Duplex({ write(c, e, cb) { cb(); } });
pipeline(a, b, (err) => {
  console.log('err', err && err.message, 'b error listeners', b.listenerCount('error'));
});
