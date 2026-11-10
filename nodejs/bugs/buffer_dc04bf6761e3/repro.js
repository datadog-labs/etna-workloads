const u = new Uint8Array([104, 105]);
function t(name, f) {
  try { console.log(name, JSON.stringify(f())); } catch (e) { console.log(name, 'threw', e.constructor.name); }
}
t('toString()', () => Buffer.prototype.toString.call(u));
t('toString(utf8,0,2)', () => Buffer.prototype.toString.call(u, undefined, 0, 2));
t('write(str)', () => Buffer.prototype.write.call(new Uint8Array(4), 'abc'));
t('write(str,off,len,ascii)', () => Buffer.prototype.write.call(new Uint8Array(4), 'abc', 0, 3, 'ascii'));
