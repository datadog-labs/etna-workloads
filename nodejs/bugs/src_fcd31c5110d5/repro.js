const tls = require('tls');
for (const m of ['%s%s', '%d', '100%%']) {
  try { tls.createSecureContext({ secureProtocol: m }); }
  catch (e) { console.log(e.code, e.message); }
}
