process.emitWarning = () => {};
const ffi = require('node:ffi');
const { functions: f, lib } = ffi.dlopen(null, { labs: { arguments: ['i64'], return: 'i64' }, llabs: { arguments: ['i64'], return: 'i64' } });
for (const v of [-5, 7, 2 ** 53, -5n]) {
  for (let i = 0; i < 3; i++) {
    try { console.log(typeof v, String(v), f.labs(v)); } catch (e) { console.log('err', e.code, e.message); }
  }
}
