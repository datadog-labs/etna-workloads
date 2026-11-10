const http = require('http');
function t(opts) {
  try {
    const s = http.createServer(opts);
    console.log(JSON.stringify(opts), 'ok', s.headersTimeout, s.requestTimeout);
    s.close();
  } catch (e) { console.log(JSON.stringify(opts), e.code, e.message); }
}
t({ requestTimeout: 10_000 });
t({ requestTimeout: 30_000 });
t({ requestTimeout: 10_000, headersTimeout: 10_000 });
t({ requestTimeout: 0 });
t({});
