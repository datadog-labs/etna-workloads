'use strict';
const { createDeflate } = require('zlib');
const s = createDeflate();
s.on('error', () => {});
s.write(Buffer.alloc(1024, 0x41), () => {});
try {
  s._handle.reset();
  console.log('reset allowed during write');
} catch (e) {
  console.log('threw:', e.message);
}
