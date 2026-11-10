'use strict';
const vm = require('vm');
const ctx = vm.createContext({});
vm.runInContext("Object.defineProperty(this, 'foo', { value: 1, configurable: false });", ctx);
try {
  vm.runInContext('let foo = 2;', ctx);
  console.log('no error');
} catch (e) {
  console.log('threw', e.name);
}
