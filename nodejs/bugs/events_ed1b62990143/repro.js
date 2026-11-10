const v8 = require('v8');
v8.setFlagsFromString('--expose-gc');
const gc = require('vm').runInNewContext('gc');
const { aborted } = require('util');

(async () => {
  const ac = new AbortController();
  const resource = {};
  let a = false, b = false;
  aborted(ac.signal, resource).then(() => { a = true; });
  aborted(ac.signal, resource).then(() => { b = true; });
  await new Promise((r) => setTimeout(r, 10));
  gc(); gc();
  await new Promise((r) => setTimeout(r, 10));
  gc();
  ac.abort();
  await new Promise((r) => setTimeout(r, 50));
  console.log('first resolved:', a, 'second resolved:', b);
  if (!a || !b) process.exitCode = 1;
  void resource;
})();
