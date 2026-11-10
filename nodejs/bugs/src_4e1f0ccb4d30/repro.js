const vm = require('node:vm');
const util = require('node:util');
const ctx = vm.createContext();
const getter = vm.runInContext('(function(o,p){return o[p];})', ctx);
console.log(typeof getter(util, 'parseArgs'));
console.log(typeof getter(globalThis, 'TextEncoder'));
