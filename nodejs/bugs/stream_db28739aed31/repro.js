const { pipeline, Readable } = require('stream');
process.on('uncaughtException', (e) => console.log('uncaught', e.message));
let n = 0;
pipeline(Readable.from(['a']), async function(source) {
  for await (const _ of source) {}
}, (err) => {
  console.log('callback', n++, err && err.message);
  throw new Error('from callback');
});
process.on('exit', (c) => console.log('exit', c));
