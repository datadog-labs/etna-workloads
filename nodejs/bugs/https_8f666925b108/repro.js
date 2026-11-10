const https = require('https');
const a = new https.Agent();
const k = (b) => a.getName({ pfx: [{ buf: Buffer.from(b), passphrase: 'p' }] });
console.log(k('one') === k('two') ? 'SAME' : 'DIFFERENT');
console.log(a.getName({ pfx: [{ buf: Buffer.from('x') }] }) === a.getName({ pfx: [{ buf: Buffer.from('y') }] }) ? 'SAME' : 'DIFFERENT');
