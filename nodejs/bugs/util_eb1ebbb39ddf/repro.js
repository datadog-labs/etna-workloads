const util = require('util');
const o = { get f() { return function foo() {}; }, get c() { return class A {}; } };
console.log(util.inspect(o, { getters: true }));
