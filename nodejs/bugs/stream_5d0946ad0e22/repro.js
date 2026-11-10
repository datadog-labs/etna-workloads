const { pipeline } = require('node:stream/promises');
async function* src() { yield 'Hello'; yield 'World'; }
const messages = [];
async function* sink(stream) { for await (const c of stream) messages.push(c); }
pipeline(src, sink).then(
  () => console.log('ok', JSON.stringify(messages)),
  (e) => { console.log('error', e && e.message); process.exitCode = 1; });
