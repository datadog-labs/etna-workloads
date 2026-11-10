'use strict';
const vm = require('vm');
const obj = {};
vm.createContext(obj);
let setterCalls = 0;
Object.defineProperty(obj, 'prop', {
  get() { return 42; },
  set() { setterCalls++; },
  configurable: true,
});
const g = vm.runInContext('this', obj);
try {
  g.prop = () => {};
  console.log('assigned');
} catch (e) {
  console.log('threw', e.constructor.name, e.message);
}
console.log('setterCalls', setterCalls, 'value', g.prop);
