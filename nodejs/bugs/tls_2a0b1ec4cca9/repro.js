const tls = require('tls');
const cases = {
  emptyStr: ['http/1.1', ''],
  zeroLenBuf: Buffer.from([0]),
  truncBuf: Buffer.from([5, 0x61]),
};
for (const [k, v] of Object.entries(cases)) {
  try {
    tls.createSecureContext();
    const o = {};
    tls.convertALPNProtocols(v, o);
    console.log(k, 'accepted');
  } catch (e) {
    console.log(k, e.code);
  }
}
