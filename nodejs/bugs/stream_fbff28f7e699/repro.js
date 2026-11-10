const { duplexPair } = require('stream');
const [a, b] = duplexPair();
b.on('close', () => console.log('b closed, destroyed=', b.destroyed));
b.on('error', (e) => console.log('b error', e && e.message));
a.on('error', (e) => console.log('a error', e.message));
a.on('close', () => console.log('a closed'));
a.destroy(new Error('boom'));
setTimeout(() => console.log('done; b.destroyed =', b.destroyed), 200);
