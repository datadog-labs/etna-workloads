'use strict';
const { Utf8Stream, write, readFileSync } = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const fs = require('node:fs');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const dest = path.join(dir, 'a.log');
const after = path.join(dir, 'b.log');
const stream = new Utf8Stream({
  dest, minLength: 0, sync: false,
  fs: {
    write(fd, buf, enc, cb) {
      if (stream.file === after) {
        setImmediate(() => write(fd, buf, enc, cb));
        return;
      }
      return write(fd, buf, enc, cb);
    },
  },
});
stream.write('hello\n');
stream.once('drain', () => {
  stream.reopen(after);
  stream.once('ready', () => stream.write('after reopen\n'));
  stream.once('drain', () => {
    console.log(JSON.stringify(readFileSync(after, 'utf8')));
    stream.destroy();
    fs.rmSync(dir, { recursive: true, force: true });
  });
});
