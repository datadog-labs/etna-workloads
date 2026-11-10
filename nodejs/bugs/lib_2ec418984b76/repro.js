const http = require('http');
const { Writable } = require('stream');
const srv = http.createServer((req, res) => {
  try {
    const w = Writable.toWeb(res);
    console.log('toWeb ok', typeof w.getWriter);
  } catch (e) {
    console.log('toWeb error', e.code);
  }
  res.end();
});
srv.listen(0, () => {
  http.get({ port: srv.address().port }, (r) => {
    r.resume();
    r.on('end', () => srv.close());
  });
});
