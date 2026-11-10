const log = [];
const init = new Proxy({}, {
  get(t, k) { if (typeof k === 'string') log.push(k); return undefined; },
  has(t, k) { return false; },
});
try { new URLPattern(init); } catch (e) {}
console.log(log.join(','));
const p = new URLPattern({ pathname: '/a' });
const r = p.exec({ pathname: '/a' });
console.log(Object.keys(r.inputs[0]).join(','));
console.log(JSON.stringify(r.inputs[0]));
