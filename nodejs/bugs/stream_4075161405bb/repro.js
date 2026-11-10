const { Duplex, Readable, pipeline } = require('stream');
const src = new Readable({ read() {}, destroy(e, cb) { console.log('source destroyed'); cb(e); } });
src.push('a');
const d = Duplex.from(async function (source) { /* returns without consuming */ });
const t = setTimeout(() => { console.log('timeout: pipeline never finished'); process.exit(1); }, 3000);
pipeline(src, d, (err) => {
  clearTimeout(t);
  console.log('pipeline done', err && err.code);
});
