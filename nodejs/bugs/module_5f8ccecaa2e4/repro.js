const Module = require('module');
const fs = require('fs'), os = require('os'), path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
const f = path.join(d, 'm.js');
fs.writeFileSync(f, 'module.exports = typeof __marker;');
Module.wrap = (s) => Module.wrapper[0] + 'var __marker = 1;' + s + Module.wrapper[1];
console.log(require(f));
fs.rmSync(d, { recursive: true });
