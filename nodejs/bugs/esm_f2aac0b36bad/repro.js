Object.defineProperty(Object.prototype, 'then', {
  configurable: true,
  get() { console.log('POLLUTED: get Object.prototype.then'); return undefined; },
});
import('data:text/javascript,').then(() => console.log('done'));
