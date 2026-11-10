'use strict';
const vm = require('vm');
const context = {};
vm.createContext(context);
vm.runInContext(`
  globalThis.a1 = 1;
  Object.defineProperty(globalThis, 'a1', { enumerable: false });
  globalThis.b1 = 1;
  Object.defineProperty(globalThis, 'b1', { writable: false });
`, context);
console.log('a1', context.a1, Object.getOwnPropertyDescriptor(context, 'a1').enumerable);
console.log('b1', context.b1);
