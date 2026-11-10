'use strict';
if (!process.execArgv.includes('--experimental-vm-modules')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--experimental-vm-modules', '--no-warnings', __filename], { encoding: 'utf8' });
  process.stdout.write(r.stdout + r.stderr);
  process.exit(r.status);
}
const { createContext, Script, SourceTextModule } = require('vm');
(async () => {
  const ctx = createContext();
  const mod1 = new SourceTextModule('export const a = 1;', { context: ctx });
  await mod1.link(() => { throw new Error('no'); });
  const s = new Script(`
    const p = import("mod1");
    globalThis.__same = Object.getPrototypeOf(p) === Promise.prototype;
    globalThis.__p = p;
  `, { importModuleDynamically: () => mod1 });
  s.runInContext(ctx);
  console.log('promise from calling context:', ctx.__same);
  await ctx.__p;
})().catch((e) => console.log('error:', e.message));
