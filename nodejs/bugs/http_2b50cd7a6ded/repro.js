const http = require('http');
const server = http.createServer((req, res) => {
  try {
    res.write(new Uint8Array([104, 105]));
    res.end(new Uint8Array([33]));
  } catch (e) {
    console.log('throw', e.code);
    res.end();
  }
});
server.listen(0, () => {
  http.get({ port: server.address().port }, (res) => {
    const c = [];
    res.on('data', (d) => c.push(d));
    res.on('end', () => {
      console.log('body', JSON.stringify(Buffer.concat(c).toString()));
      server.close();
    });
  });
});
