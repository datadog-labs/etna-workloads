const { pipeline, Writable } = require('stream');
const chunks = [];
try {
  pipeline(
    '',
    new Writable({ write(c, e, cb) { chunks.push(String(c)); cb(); } }),
    (err) => {
      console.log('err:', err ? err.code || err.message : null);
      console.log('chunks:', JSON.stringify(chunks));
    }
  );
} catch (e) {
  console.log('threw:', e.code);
}
