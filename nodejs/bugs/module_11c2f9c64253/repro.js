const { registerHooks } = require('module');
const h = registerHooks({ resolve(s, c, n) { return n(s, c); } });
console.log(typeof h[Symbol.dispose]);
console.log(h[Symbol.dispose] === h.deregister);
try { h[Symbol.dispose](); console.log('disposed'); } catch (e) { console.log('err', e.constructor.name); }
