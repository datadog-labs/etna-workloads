const zlib = require('zlib');
const s = zlib.createGzip({ decodeStrings: false });
s.on('error', (e) => console.log('error', e.code));
s.on('data', () => {});
s.on('end', () => console.log('end'));
s.write('hello');
s.end();
