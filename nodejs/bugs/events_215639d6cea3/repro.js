const { addAbortListener } = require('events');
const ac = new AbortController();
ac.abort();
addAbortListener(ac.signal, (e) => {
  console.log('event type:', e && e.type);
  console.log('target is signal:', e && e.target === ac.signal);
});
const d = addAbortListener(ac.signal, () => console.log('should not run'));
d[Symbol.dispose]();
