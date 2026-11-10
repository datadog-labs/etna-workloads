const util = require('util');
const { proxy, revoke } = Proxy.revocable({}, {});
revoke();
for (const opts of [{}, { showProxy: true }]) {
  try { console.log(util.inspect(proxy, opts)); } catch (e) { console.log('threw', e.constructor.name); }
}
try { console.dir(proxy); } catch (e) { console.log('threw', e.constructor.name); }
try { console.log(util.inspect({ a: proxy })); } catch (e) { console.log('threw', e.constructor.name); }
