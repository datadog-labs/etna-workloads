const { subtle } = globalThis.crypto;
(async () => {
  const kp = await subtle.generateKey({ name: 'ECDSA', namedCurve: 'P-256' }, true, ['sign', 'verify']);
  try {
    const r = await subtle.exportKey('pkcs8', kp.publicKey);
    console.log('no error', r && r.byteLength);
  } catch (e) { console.log(e.name, e.message); }
  const wk = await subtle.generateKey({ name: 'AES-KW', length: 128 }, true, ['wrapKey', 'unwrapKey']);
  try {
    await subtle.wrapKey('pkcs8', kp.publicKey, wk, 'AES-KW');
    console.log('no error');
  } catch (e) { console.log(e.name, e.message); }
})();
