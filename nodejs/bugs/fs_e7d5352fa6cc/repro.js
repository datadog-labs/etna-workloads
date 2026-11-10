const fs = require('fs');
const s = fs.createReadStream('x', {
  fs: {
    open(p, f, m, cb) { cb(null, 0); },
    read(fd, buf, off, len, pos, cb) { cb(null, 0); },
    close(fd, cb) { console.log('close called fd=' + fd); cb(); },
  },
});
s.on('close', () => console.log('stream closed'));
s.resume();
