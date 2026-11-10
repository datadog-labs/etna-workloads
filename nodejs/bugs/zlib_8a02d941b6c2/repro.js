const zlib = require('zlib');
const ts = zlib.createGzip();
ts.destroy();
console.log('handle null:', ts._handle === null);
