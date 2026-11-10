const { Readable } = require('stream');
const EE = require('events');
for (const ev of ['destroy', 'close']) {
  const old = new EE();
  old.pause = () => {}; old.resume = () => {};
  const r = new Readable({ autoDestroy: false, destroy(e, cb) { console.log(ev, 'destroy called'); cb(e); } });
  r.wrap(old);
  old.emit(ev);
  console.log(ev, 'destroyed =', r.destroyed);
}
