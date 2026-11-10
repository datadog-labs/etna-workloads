const net = require('net');
const dns = require('dns');
dns.lookup = (host, options, cb) => {
  if (typeof options === 'function') cb = options;
  cb(null, [
    { address: 'fe80::1', family: 6 },
    { address: '127.0.0.1', family: 4 },
  ]);
};
const s = net.createServer();
s.on('error', (e) => { console.log('error', e.code || e.message); });
s.listen(0, 'mocked-host', () => {
  console.log('listening on', s.address().address);
  s.close();
});
