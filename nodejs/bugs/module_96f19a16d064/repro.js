'use strict';
const { registerHooks } = require('module');
const v = new Map([
  ['virtual:shared', 'module.exports.greet = (name) => "hello " + name;'],
  ['virtual:entry', 'const { greet } = require("virtual:shared");\nmodule.exports = greet("world");'],
]);
registerHooks({
  resolve(s, c, next) {
    if (v.has(s)) return { url: s, format: 'commonjs', shortCircuit: true };
    return next(s, c);
  },
  load(u, c, next) {
    if (v.has(u)) return { format: 'commonjs', source: v.get(u), shortCircuit: true };
    return next(u, c);
  },
});
import('virtual:entry').then((ns) => console.log('ok', ns.default),
  (e) => console.log('error', e.code));
