const { spawnSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'cc-'));
const build = path.join(root, 'build');
fs.mkdirSync(build);
const entry = (d) => path.join(d, 'entry.js');
fs.writeFileSync(entry(build), `
require('module').enableCompileCache({ directory: '.cc' });
require('./dep.js');
`);
fs.writeFileSync(path.join(build, 'dep.js'), 'module.exports = 1;\n');
function run(dir, cc) {
  const r = spawnSync(process.execPath, [entry(dir)], {
    cwd: root, encoding: 'utf8',
    env: { ...process.env, NODE_DEBUG_NATIVE: 'COMPILE_CACHE', NODE_COMPILE_CACHE_PORTABLE: '1' },
  });
  return /dep\.js was accepted|dep\.js.*accepted|because cache was the same/.test(r.stderr);
}
// relative dir resolves against cwd (root), so use cwd-relative cache inside build
fs.writeFileSync(entry(build), `
require('module').enableCompileCache({ directory: require('path').join(__dirname, '.cc') });
require('./dep.js');
`);
run(build);
const moved = build + '_moved';
fs.renameSync(build, moved);
console.log('cache accepted after move (portable via env):', run(moved));
fs.rmSync(root, { recursive: true, force: true });
