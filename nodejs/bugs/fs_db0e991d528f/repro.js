const fs = require('fs'), os = require('os'), path = require('path');
const f = path.join(os.tmpdir(), 'repro-pool-' + process.pid);
fs.writeFileSync(f, 'hello world');
fs.createReadStream(f).on('data', (c) => {
  console.log('length', c.length, 'backing', c.buffer.byteLength, 'offset', c.byteOffset);
}).on('close', () => { fs.unlinkSync(f); });
