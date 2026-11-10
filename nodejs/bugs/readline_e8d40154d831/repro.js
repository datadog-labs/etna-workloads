const readline = require('node:readline');
const { Readable } = require('node:stream');
const input = Readable.from((function*() { yield 'a\nb'; yield '\r\n'; })());
const rl = readline.createInterface({ input, crlfDelay: Infinity });
const lines = [];
rl.on('line', (l) => lines.push(l));
rl.on('close', () => console.log(JSON.stringify(lines)));
