const { registerHooks } = require('module');
const out = [];
const h = registerHooks({
  resolve(s, c, next) {
    try { const r = next(s, c); out.push(`resolve ${s} url=${r.url}`); return r; }
    catch (e) { out.push(`resolve ${s} threw ${e.code}`); throw e; }
  },
  load(u, c, next) { out.push(`load ${u}`); return next(u, c); },
});
for (const m of ['node:test', 'node:fs']) {
  try { require(m); } catch (e) { out.push(`error ${m}: ${e.message}`); }
}
h.deregister();
console.log(out.join('\n'));
