const tls = require('tls');
const cert = { subject: { CN: 'x' }, subjectaltname: 'IP Address:127.0.0.1', infoAccess: {} };
for (const h of ['127.0.0.1', '0x7f.0.0.1', '0177.0.0.1', '2130706433']) {
  const e = tls.checkServerIdentity(h, cert);
  console.log(h, e ? e.code + ': ' + e.reason : 'accepted');
}
