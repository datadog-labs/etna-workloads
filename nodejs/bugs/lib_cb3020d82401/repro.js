const readline = require('readline');
const { Readable } = require('stream');
const input = new Readable({ read() {} });
const rl = readline.createInterface({ input });
rl.on('error', (e) => { console.log('rl error:', e.message); });
process.on('uncaughtException', (e) => console.log('uncaught:', e.message));
input.emit('error', new Error('boom'));
setTimeout(() => console.log('done'), 100);
