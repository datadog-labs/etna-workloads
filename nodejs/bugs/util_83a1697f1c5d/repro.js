const util = require('util');
const dv = new DataView(new ArrayBuffer(4));
structuredClone(dv.buffer, { transfer: [dv.buffer] });
console.log(util.inspect({ a: dv, b: { c: 1 } }, { showHidden: true }));
console.log(util.inspect([dv, [1]], { showHidden: true }));
