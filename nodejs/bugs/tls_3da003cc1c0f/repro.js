const tls = require('tls');
const s = tls.connect('cause-error');
s.on('error', () => {});
s.on('close', () => {
  s.on('keylog', () => {});
  console.log('keylog ok');
  const t = tls.connect('cause-error-2');
  t.on('error', () => {});
  t.on('close', () => { t.on('session', () => {}); console.log('session ok'); });
});
