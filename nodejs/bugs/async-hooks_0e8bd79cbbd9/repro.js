const asyncHooks = require('async_hooks');
const vm = require('vm');
const hook = asyncHooks.createHook({ init() {} }).enable();
vm.createContext();
globalThis.gc ? globalThis.gc() : require('v8').setFlagsFromString('--expose-gc');
if (!globalThis.gc) globalThis.gc = require('vm').runInNewContext('gc');
globalThis.gc();
hook.disable();
console.log('ok');
