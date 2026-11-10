const { subtle } = globalThis.crypto;
(async () => {
  const k = await subtle.generateKey({ name: 'AES-GCM', length: 256 }, true,
    ['decrypt', 'encrypt', 'decrypt']);
  console.log(JSON.stringify(k.usages));
  const p = await subtle.generateKey('ML-KEM-768', true,
    ['decapsulateKey', 'decapsulateBits', 'encapsulateKey', 'encapsulateBits']).catch(e => e);
  console.log(p.privateKey ? JSON.stringify([p.privateKey.usages, p.publicKey.usages]) : p.message);
  const o = await subtle.generateKey({ name: 'AES-GCM', length: 128 }, true,
    ['wrapKey', 'unwrapKey', 'sign'].slice(0,2));
  console.log(JSON.stringify(o.usages));
})();
