const vm = require('vm');
const sb = { __proto__: { inherited: 1 }, a: 1, 5: 2 };
Object.defineProperty(sb, 'hidden', { value: 1, enumerable: false });
sb[Symbol('s')] = 1;
const ctx = vm.createContext(sb);
console.log(vm.runInContext('Object.getOwnPropertyNames(globalThis).filter(k=>["a","5","hidden","inherited"].includes(k)).sort().join()', ctx));
console.log(vm.runInContext('Reflect.ownKeys(globalThis).filter(k=>typeof k==="symbol").length', ctx));
