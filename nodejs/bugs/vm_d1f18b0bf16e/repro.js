'use strict';
const vm = require('vm');
const outerProto = { onOuterProto: 'x' };
Object.defineProperty(outerProto, 0, { value: 'idx', configurable: true });
Object.defineProperty(outerProto, 'g', { get() { return 'getter'; } });
const sandbox = { __proto__: { __proto__: outerProto }, onSelf: 's' };
const ctx = vm.createContext(sandbox);
const out = [];
for (const k of ['onSelf', 'onOuterProto', 'g', '0', 'nope']) {
  out.push(k + ': ' + vm.runInContext(`Object.getOwnPropertyDescriptor(globalThis, ${JSON.stringify(k)}) === undefined ? 'undef' : 'desc'`, ctx)
    + ' in=' + vm.runInContext(`${JSON.stringify(k)} in globalThis`, ctx)
    + ' hop=' + vm.runInContext(`Object.prototype.hasOwnProperty.call(globalThis, ${JSON.stringify(k)})`, ctx)
    + ' pie=' + vm.runInContext(`Object.prototype.propertyIsEnumerable.call(globalThis, ${JSON.stringify(k)})`, ctx));
}
console.log(out.join('\n'));
console.log(vm.runInContext('Object.getOwnPropertyDescriptor(globalThis,"g")', ctx));
