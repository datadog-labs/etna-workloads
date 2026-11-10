const { Readable } = require('stream');
process.on('uncaughtException', (e) => { console.log('uncaught', e.code); process.exit(1); });
const readable = new Readable({ read() { this.push(Buffer.alloc(1024)); } });
const webStream = Readable.toWeb(readable);
const reader = webStream.getReader();
(async () => {
  await reader.read();
  await reader.read();
  reader.releaseLock();
  await webStream.cancel();
  await new Promise((r) => setTimeout(r, 200));
  console.log('ok');
})();
