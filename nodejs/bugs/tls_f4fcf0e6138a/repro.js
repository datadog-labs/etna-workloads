const tls = require('tls');
try {
  tls.createSecureContext({ clientCertEngine: 'x' });
  console.log('no error');
} catch (e) {
  console.log(e.code, e.name, /could not load the shared library/.test(e.message),
              Array.isArray(e.opensslErrorStack), e.opensslErrorStack && e.opensslErrorStack.length > 0);
}
