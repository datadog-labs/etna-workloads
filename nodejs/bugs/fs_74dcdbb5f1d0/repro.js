const fs = require('fs'), os = require('os'), path = require('path');
const cwd = fs.mkdtempSync(path.join(os.tmpdir(), 'globrepro-'));
const a = path.join(cwd, 'a');
fs.mkdirSync(path.join(a, 'b', 'c', 'd'), { recursive: true });
fs.mkdirSync(path.join(a, 'c', 'd', 'c'), { recursive: true });
fs.writeFileSync(path.join(a, 'x'), '');
fs.writeFileSync(path.join(a, 'z'), '');
// Pin directory iteration order (the bug depends on it).
const orig = fs.readdirSync;
fs.readdirSync = function(target, options) {
  const entries = orig.call(this, target, options);
  if (!Array.isArray(entries) || target !== a) return entries;
  return ['c', 'b', 'x', 'z'].map((n) => entries.find((e) => e.name === n)).filter(Boolean);
};
const results = fs.globSync('a/**/../*', { cwd }).sort();
console.log(results.join('\n'));
fs.rmSync(cwd, { recursive: true, force: true });
