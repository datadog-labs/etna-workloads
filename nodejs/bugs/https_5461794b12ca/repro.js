const https = require('https');
const s = https.createServer({});
console.log('default requestTimeout:', s.requestTimeout);
const s2 = https.createServer({ requestTimeout: 5000 });
console.log('explicit requestTimeout:', s2.requestTimeout);
