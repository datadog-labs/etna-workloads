const { subtle } = globalThis.crypto;
(async () => {
  const k = await subtle.importKey('raw', new Uint8Array(32), { name: 'AES-GCM' }, false, ['decrypt']);
  try {
    await subtle.decrypt({ name: 'AES-GCM', iv: new Uint8Array(12) }, k, new Uint8Array(0));
    console.log('resolved');
  } catch (e) { console.log('rejected', e.name); }
})();
