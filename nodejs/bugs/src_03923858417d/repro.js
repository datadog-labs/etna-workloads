const zlib = require('zlib');
console.log(zlib.constants.BROTLI_DECODER_ERROR_FORMAT_BLOCK_SWITCH);
try { zlib.brotliDecompressSync(Buffer.from([0x0b,0x02,0x80,0x61,0x62,0x63,0x03,0xff,0xff,0xff,0xff])); } catch (e) { console.log(e.code, e.errno); }
