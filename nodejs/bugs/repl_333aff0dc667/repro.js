'use strict';
const readline = require('readline');
const { PassThrough } = require('stream');
const rli = new readline.Interface({ terminal: true, input: new PassThrough(), output: new PassThrough() });
let depth = 0;
const lines = [];
rli.on('line', (l) => {
  lines.push(l);
  if (depth > 2) return;
  depth++;
  rli.write('foo');
});
rli.write(' \n}\n');
console.log('lines:', JSON.stringify(lines));
console.log('depth:', depth);
rli.close();
