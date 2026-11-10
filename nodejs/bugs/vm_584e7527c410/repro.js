'use strict';
const vm = require('node:vm');
const ctx = vm.createContext(new Proxy({}, {}));
vm.runInContext(`
Object.defineProperty(this, 'foo', {value: 42, writable: true, enumerable: true, configurable: true});
Object.defineProperty(this, 'hidden', {value: 1, enumerable: false, configurable: true});
Object.defineProperty(this, 'readonly', {value: 2, writable: false, enumerable: true, configurable: true});
`, ctx);
const r = vm.runInContext(`({
  d: JSON.stringify(Object.getOwnPropertyDescriptor(globalThis, 'foo')),
  ro: JSON.stringify(Object.getOwnPropertyDescriptor(globalThis, 'readonly')),
  hasOwn: Object.hasOwn(globalThis, 'foo'),
  keys: Object.keys(globalThis).join(),
  hiddenEnum: Object.prototype.propertyIsEnumerable.call(globalThis, 'hidden'),
  hasOwnToString: Object.hasOwn(globalThis, 'toString'),
})`, ctx);
console.log(r);
