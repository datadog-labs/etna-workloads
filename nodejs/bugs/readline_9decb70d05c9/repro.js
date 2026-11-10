const { Readable, Writable } = require('stream');
const readline = require('readline');
const rli = new readline.Interface({
  terminal: true,
  input: new Readable({ read() {} }),
  output: new Writable({ write(c, e, cb) { cb(); } }),
});
const lines = [];
rli.on('line', (l) => lines.push(l));
rli.write('{\n}');
console.log(JSON.stringify({ lines, pending: rli.line }));
rli.close();
