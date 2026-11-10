'use strict';
const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'rw-'));
const root = path.join(dir, 'root');
fs.mkdirSync(root);
const origWatch = fs.watch;
const origRead = fs.readdirSync;
const ops = [];
let first = true;
fs.watch = function(f, ...a) {
  if (f === root) {
    ops.push('watch');
    if (first) { first = false; fs.rmSync(root, { recursive: true }); }
    return { close() {} };
  }
  return origWatch.call(this, f, ...a);
};
fs.readdirSync = function(f, ...a) {
  if (f === root) ops.push('read');
  return origRead.call(this, f, ...a);
};
let result;
try {
  const w = origWatch.call(fs, root, { recursive: true });
  w.close();
  result = 'no error';
} catch (e) {
  result = 'threw ' + e.code;
}
fs.watch = origWatch;
fs.readdirSync = origRead;
console.log(ops.join(','), result);
fs.rmSync(dir, { recursive: true, force: true });
