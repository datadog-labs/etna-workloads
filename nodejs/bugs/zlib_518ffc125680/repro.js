const zlib = require('zlib');
const d = zlib.createDeflate();
const out = [];
d.on('data', (c) => out.push(c.length));
let cbs = 0;
d.write('hello');
d.flush(() => cbs++);
d.write('world');
d.flush(() => cbs++);
d.flush(() => cbs++);
d.end();
d.on('end', () => {
  console.log('chunks', out.length, 'callbacks', cbs);
});
