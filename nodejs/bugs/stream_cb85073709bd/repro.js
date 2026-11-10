const fs = require('fs');
const os = require('os');
const path = require('path');
const file = path.join(os.tmpdir(), 'repro-open-write-' + process.pid + '.txt');
const w = fs.createWriteStream(file);
w.on('open', () => {
  w.write('hello');
  process.nextTick(() => {
    w.write('world');
    w.end();
  });
});
w.on('close', () => {
  console.log(fs.readFileSync(file, 'utf8'));
  fs.unlinkSync(file);
});
