const tls = require('tls');
const cert = { subject: { CN: 'a.com' }, subjectaltname: 'IP Address:127.0.0.1' };
for (const h of ['127.0.0.1', '127.1', '１２７.0.0.1', '127。0.0.1']) {
  const e = tls.checkServerIdentity(h, cert);
  console.log(JSON.stringify(h), e ? e.reason : 'ok');
}
