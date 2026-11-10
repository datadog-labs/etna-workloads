const fs = require('fs');
let buf;
try { buf = Buffer.allocUnsafe(2 ** 31 + 1); } catch { console.log('alloc fail'); process.exit(0); }
const fd = fs.openSync('/dev/null', 'w');
try {
  console.log('wrote', fs.writeSync(fd, buf, 0, buf.length));
} catch (e) {
  console.log(e.code);
}
fs.closeSync(fd);
