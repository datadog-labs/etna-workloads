const fs = require('fs'), os = require('os'), path = require('path'), cp = require('child_process');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
fs.mkdirSync(path.join(d, 'node_modules', 'pkg'), { recursive: true });
fs.writeFileSync(path.join(d, 'node_modules', 'pkg', 'index.js'),
  "module.exports=(u)=>{const e=new (require('events'))();e.on('x',require('url').parse);e.emit('x',u);};\n");
fs.writeFileSync(path.join(d, 'main.js'), "require('pkg')('http://a.com/x');console.log('done');\n");
const r = cp.spawnSync(process.execPath, ['main.js'], { cwd: d, encoding: 'utf8' });
console.log(r.status, r.stdout, /DEP0169/.test(r.stderr) ? 'WARNED' : 'no warning');
fs.rmSync(d, { recursive: true, force: true });
