if (!process.execArgv.includes('--experimental-vfs')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--experimental-vfs', '--no-warnings', __filename], { stdio: 'inherit' });
  process.exit(r.status);
}
const vfs = require('node:vfs');
const v = vfs.create();
v.mkdirSync('/a');
v.writeFileSync('/a/f', 'x');
v.mkdirSync('/b');
v.writeFileSync('/b/g', 'y');
try { v.renameSync('/a', '/b'); console.log('rename ok'); } catch (e) { console.log(e.code); }
console.log(v.existsSync('/a/f'), v.existsSync('/b/g'));
v.writeFileSync('/h1', 'z');
v.linkSync?.('/h1', '/h2');
console.log(v.existsSync('/h2'));
