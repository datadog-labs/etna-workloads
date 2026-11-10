const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const pkg = path.join(dir, 'node_modules', 'pkg');
fs.mkdirSync(pkg, { recursive: true });
fs.writeFileSync(path.join(pkg, 'index.js'), 'module.exports = "index";');
// package.json is a self-referencing symlink: exists but cannot be read (ELOOP)
fs.symlinkSync('package.json', path.join(pkg, 'package.json'));
fs.writeFileSync(path.join(dir, 'main.js'), 'module.exports = require("pkg");');
try {
  console.log('resolved:', require(path.join(dir, 'main.js')));
} catch (e) {
  console.log('error:', e.code);
}
fs.rmSync(dir, { recursive: true, force: true });
