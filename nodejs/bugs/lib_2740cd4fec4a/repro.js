const v8 = require('v8');
v8.setFlagsFromString('--expose-gc');
const gc = require('vm').runInNewContext('gc');
const refs = [];
for (let i = 0; i < 10; i++) {
  const t = setTimeout(() => {}, 0);
  +t;
  refs.push(new WeakRef(t));
}
let n = 0;
const iv = setInterval(() => {
  gc();
  const alive = refs.filter((r) => r.deref()).length;
  if (alive === 0 || ++n > 10) {
    clearInterval(iv);
    console.log('timers still alive:', alive);
  }
}, 20);
