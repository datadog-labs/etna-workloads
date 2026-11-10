const crypto = require('crypto');
const ab = new ArrayBuffer(32);
const view = new Uint8Array(ab, 16, 16);
crypto.randomFillSync(view);
const u = new Uint8Array(ab);
console.log('before view untouched:', u.slice(0, 16).every((b) => b === 0));
console.log('view filled:', view.some((b) => b !== 0));
