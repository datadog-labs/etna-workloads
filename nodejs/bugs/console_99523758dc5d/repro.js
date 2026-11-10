const { Console } = require('console');
const { Writable } = require('stream');
process.env.TERM = 'dumb';
let out = '';
const s = new Writable({ write(c, e, cb) { out += c; cb(); } });
s.isTTY = true;
new Console(s).clear();
console.log(JSON.stringify(out));
