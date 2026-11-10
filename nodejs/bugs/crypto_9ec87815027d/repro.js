const crypto = require('crypto');
function t(name, f) {
  try { f(); console.log(name, 'ok'); } catch (e) { console.log(name, 'throws', e.code); }
}
const odd = Buffer.from('abc');
t('hash', () => crypto.createHash('sha256').update(odd, 'hex'));
t('hmac', () => crypto.createHmac('sha256', 'k').update(odd, 'hex'));
t('cipher', () => crypto.createCipheriv('aes-128-ecb', Buffer.alloc(16), null).update(odd, 'hex'));
t('decipher', () => crypto.createDecipheriv('aes-128-ecb', Buffer.alloc(16), null).update(odd, 'hex'));
