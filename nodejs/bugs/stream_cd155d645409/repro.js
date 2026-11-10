const util = require('util');
console.log(util.inspect(new CompressionStream('gzip')));
console.log(util.inspect(new DecompressionStream('gzip')));
