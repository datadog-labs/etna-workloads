const { Resolver } = require('dns');
const r = new Resolver();
r._handle.getServers = () => undefined;
try { console.log(r.getServers().length); } catch (e) { console.log('error', e.constructor.name); }
