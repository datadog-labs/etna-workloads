const util = require('util');
function t(name, fn) {
  try { console.log(name, fn()); } catch (e) { console.log(name, 'threw', e.name); }
}
t('set-null', () => util.isDeepStrictEqual(new Set([null, {a: 1}, {b: 1}]), new Set([{c: 1}, {d: 1}, {e: 1}])));
t('set-undef', () => util.isDeepStrictEqual(new Set([undefined, {a: 1}, {b: 1}]), new Set([{c: 1}, {d: 1}, {e: 1}])));
t('map-null', () => util.isDeepStrictEqual(
  new Map([[null, 1], [{a: 1}, 1], [{b: 1}, 1]]),
  new Map([[{c: 1}, 1], [{d: 1}, 1], [{e: 1}, 1]])));
