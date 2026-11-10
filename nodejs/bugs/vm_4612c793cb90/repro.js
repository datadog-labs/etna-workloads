if (!process.argv.includes('--child')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--experimental-vm-modules', '--no-warnings', __filename, '--child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout + r.stderr);
  process.exit(r.status);
}
const vm = require('vm');
(async () => {
  const m = new vm.SourceTextModule('await 1;');
  console.log(typeof m.hasTopLevelAwait, typeof m.hasAsyncGraph);
  try { console.log(m.hasTopLevelAwait()); } catch (e) { console.log('err', e.message); }
  try { m.hasAsyncGraph(); } catch (e) { console.log(e.code); }
  await m.link(() => {});
  try { console.log(m.hasAsyncGraph()); } catch (e) { console.log('err', e.message); }
})();
