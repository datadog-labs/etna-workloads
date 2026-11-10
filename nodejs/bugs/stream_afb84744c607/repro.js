const { Readable } = require('stream');
const r = new Readable({ read() {} });
r.push(Buffer.from('abc'));
r.push(Buffer.from('def'));
r.setEncoding('utf8');
r.on('data', (d) => console.log(typeof d, JSON.stringify(d.toString())));
r.push(null);
r.on('end', () => console.log('end'));
