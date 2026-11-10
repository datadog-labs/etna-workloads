const net = require('net');
const server = net.createServer((s) => s.end()).listen(0, () => {
  const client = net.connect(server.address().port, () => {
    let sync = true;
    client.on('error', (e) => {
      console.log('error', e.code, 'sync=' + sync);
      server.close();
    });
    client.on('end', () => {
      const ret = client.write('hello', (e) => console.log('cb', e.code));
      console.log('ret', ret);
      sync = false;
    });
    client.end();
  });
});
