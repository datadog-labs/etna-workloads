const { pipeline } = require('stream/promises');
const { Readable } = require('stream');
const t = setTimeout(() => { console.log('deadlock: pipeline never settled'); process.exit(1); }, 3000);
pipeline(Readable.from(Array.from({length: 100}, (_, i) => i)), async function* (src) {
  for await (const c of src) yield c;
}).then(() => { console.log('resolved'); clearTimeout(t); },
        (e) => { console.log('rejected', e.message); clearTimeout(t); });
