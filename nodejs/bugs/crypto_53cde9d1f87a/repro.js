const { subtle } = require('crypto').webcrypto;
async function t(name, fn) {
  try { await fn(); console.log(name, 'ok'); }
  catch (e) { console.log(name, e.name); }
}
(async () => {
  const ec = await subtle.generateKey({ name: 'ECDSA', namedCurve: 'P-256' }, true, ['sign', 'verify']);
  await t('ec private raw', () => subtle.exportKey('raw', ec.privateKey));
  await t('ec private raw-public', () => subtle.exportKey('raw-public', ec.privateKey));
  const kem = await subtle.generateKey({ name: 'ML-KEM-768' }, true, ['encapsulateBits', 'decapsulateBits']);
  await t('kem public raw-seed', () => subtle.exportKey('raw-seed', kem.publicKey));
  await t('kem private raw-public', () => subtle.exportKey('raw-public', kem.privateKey));
})();
