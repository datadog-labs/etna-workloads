'use strict';
const vm = require('vm');
let count = 0;
const sandbox = new Proxy({}, {
  defineProperty(t, k, d) { count++; return Reflect.defineProperty(t, k, d); },
});
const ctx = vm.createContext(sandbox);
vm.runInContext(`
  Object.defineProperty(this, 'a', { value: 1 });
  Object.defineProperty(this, 'b', { value: 2, writable: true });
  Object.defineProperty(this, 'c', { get() { return 3; } });
`, ctx);
console.log('defineProperty trap calls:', count);
