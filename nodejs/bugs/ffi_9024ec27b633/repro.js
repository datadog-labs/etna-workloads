process.removeAllListeners('warning');
process.emitWarning = () => {};
const ffi = require('node:ffi');
const { lib, functions } = ffi.dlopen(null, {
  abs: { return: 'i32', arguments: ['i32'] },
  labs: { return: 'i64', arguments: ['i64'] },
  atoi: { return: 'i32', arguments: ['string'] },
});
for (const n of Object.keys(functions)) {
  const f = functions[n];
  console.log(n, 'hasPrototype:', Object.hasOwn(f, 'prototype'));
  try { Reflect.construct(f, [-5]); console.log(n, 'constructed'); }
  catch (e) { console.log(n, e.constructor.name); }
}
lib.close();
