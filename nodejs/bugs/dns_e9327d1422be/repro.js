const dns = require('dns');
try {
  dns.setServers(['127.0.0.1:0']);
  console.log('ok', dns.getServers());
} catch (e) {
  console.log('error', e.code);
}
