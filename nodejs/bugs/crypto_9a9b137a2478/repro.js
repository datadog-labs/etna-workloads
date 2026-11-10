const { subtle } = globalThis.crypto;
(async () => {
  const kp = await subtle.generateKey({ name: 'ECDSA', namedCurve: 'P-256' }, true, ['sign', 'verify']);
  try {
    const r = await subtle.exportKey('spki', kp.privateKey);
    console.log('exported', Object.prototype.toString.call(r), r && r.byteLength);
  } catch (e) { console.log('error', e.name); }
  try {
    const wk = await subtle.generateKey({ name: 'AES-KW', length: 128 }, true, ['wrapKey', 'unwrapKey']);
    const r = await subtle.wrapKey('spki', kp.privateKey, wk, 'AES-KW');
    console.log('wrapped', r.byteLength);
  } catch (e) { console.log('wrap error', e.name); }
})();
