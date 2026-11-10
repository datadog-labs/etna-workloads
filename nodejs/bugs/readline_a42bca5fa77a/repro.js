const readline = require('readline');
const { Readable } = require('stream');
const input = Readable.from(['a b c\nd\n']);
const rl = readline.createInterface({ input });
const lines = [];
rl.on('line', (l) => lines.push(l));
rl.on('close', () => console.log(JSON.stringify(lines)));
