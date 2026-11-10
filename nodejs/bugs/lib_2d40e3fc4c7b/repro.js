const dc = require('diagnostics_channel');
const name = 'my-channel';
const t = (label) => {
  try { console.log(label, dc.hasSubscribers(name)); } catch (e) { console.log(label, 'error:', e.constructor.name); }
};
t('before channel:');
const ch = dc.channel(name);
t('after channel, no sub:');
ch.subscribe(() => {});
t('with sub:');
