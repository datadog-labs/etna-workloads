const { Readable } = require('stream');
const r = new Readable({ read() {} });
r.setEncoding('utf8');
r.push('abc');
r.push('defgh');
r.push(null);
try {
  console.log(JSON.stringify(r.read(5)));
  console.log(JSON.stringify(r.read(3)));
  console.log(JSON.stringify(r.read(1)));
} catch (e) { console.log(e.name); process.exitCode = 1; }
