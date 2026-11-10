if (!process.execArgv.includes('--experimental-vm-modules')) {
  const r = require('child_process').spawnSync(process.execPath, ['--experimental-vm-modules', '--no-warnings', __filename], { stdio: 'inherit' });
  process.exit(r.status);
}
const vm = require('vm');
const sources = {
  './index.js': 'import foo from "./foo.js"; import shared from "./shared.js"; export default {foo, shared};',
  './foo.js': 'import shared from "./shared.js"; export default {name:"foo"};',
  './shared.js': 'export default {name:"shared"};',
};
const cache = new Map();
function get(id) {
  let m = cache.get(id);
  if (!m) { m = new vm.SourceTextModule(sources[id], { identifier: id }); cache.set(id, m); }
  return m;
}
(async () => {
  try {
    const m = get('./index.js');
    await m.link(async (spec, ref) => {
      await Promise.resolve();
      const d = get(spec);
      await d.link(async (s) => { await Promise.resolve(); return get(s); });
      return d;
    });
    await m.evaluate();
    console.log('ok', m.namespace.default.foo.name, m.namespace.default.shared.name);
  } catch (e) { console.log('error:', e.code, e.message); }
})();
