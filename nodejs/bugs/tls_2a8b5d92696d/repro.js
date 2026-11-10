'use strict';
// Throwaway keys, certificates and CRLs are generated at run time with the openssl CLI
// in a private temporary directory (equivalent to the objects this reproducer was written
// with: same key types/encodings, DNs, serials, dates, extensions, CRL entries); no key
// material is embedded in this file and none is printed.
// Child processes that re-run this file inherit the same objects via REPRO_PEM.
const __pem = (() => {
  if (process.env.REPRO_PEM) return JSON.parse(process.env.REPRO_PEM);
  const { execFileSync } = require('child_process');
  const __fs = require('fs'), __os = require('os'), __path = require('path');
  const dir = __fs.mkdtempSync(__path.join(__os.tmpdir(), 'repro-pem-'));
  try {
    for (const s of [{"run": ["genpkey", "-algorithm", "RSA", "-pkeyopt", "rsa_keygen_bits:2048", "-pkeyopt", "rsa_keygen_primes:2", "-out", "o2.p8"]}, {"run": ["pkey", "-in", "o2.p8", "-traditional", "-out", "o2.pem"]}, {"run": ["genpkey", "-algorithm", "RSA", "-pkeyopt", "rsa_keygen_bits:2048", "-pkeyopt", "rsa_keygen_primes:2", "-out", "o0k.p8"]}, {"run": ["pkey", "-in", "o0k.p8", "-out", "o0k.pem"]}, {"write": "o0.cnf", "content": "[ca]\ndefault_ca = ca_o0\n[ca_o0]\ndir = .\ndatabase = ./o0.index\nnew_certs_dir = .\nserial = ./o0.serial\ndefault_md = sha256\npolicy = pol_any\nunique_subject = no\nemail_in_dn = yes\ncopy_extensions = none\n\n[pol_any]\ncountryName = optional\nstateOrProvinceName = optional\nlocalityName = optional\norganizationName = optional\norganizationalUnitName = optional\ncommonName = optional\nemailAddress = optional\n[ext]\n\n[req]\ndistinguished_name = dn\n[dn]\n"}, {"write": "o0.index", "content": ""}, {"write": "o0.serial", "content": "6CA1E32104C381DF8469588CFA483FD4C1AAAABB\n"}, {"run": ["req", "-new", "-config", "o0.cnf", "-key", "o0k.p8", "-subj", "/C=US/ST=CA/L=SF/O=Joyent/OU=Node.js/CN=ca2/emailAddress=ry@tinyclouds.org", "-multivalue-rdn", "-out", "o0.csr"]}, {"run": ["ca", "-batch", "-config", "o0.cnf", "-in", "o0.csr", "-out", "o0.crt", "-startdate", "20240827225844Z", "-enddate", "22980611225844Z", "-md", "sha256", "-preserveDN", "-notext", "-selfsign", "-keyfile", "o0k.p8"]}, {"run": ["x509", "-in", "o0.crt", "-out", "o0.pem"]}, {"write": "o1.cnf", "content": "[ca]\ndefault_ca = ca_o1\n[ca_o1]\ndir = .\ndatabase = ./o1.index\nnew_certs_dir = .\nserial = ./o1.serial\ndefault_md = sha256\npolicy = pol_any\nunique_subject = no\nemail_in_dn = yes\ncopy_extensions = none\n\n[pol_any]\ncountryName = optional\nstateOrProvinceName = optional\nlocalityName = optional\norganizationName = optional\norganizationalUnitName = optional\ncommonName = optional\nemailAddress = optional\n[ext]\n\n[req]\ndistinguished_name = dn\n[dn]\n"}, {"write": "o1.index", "content": ""}, {"write": "o1.serial", "content": "7B67075230D39AD32A32FE5DCFB1FA95E2EA319D\n"}, {"run": ["req", "-new", "-config", "o1.cnf", "-key", "o2.p8", "-subj", "/C=US/ST=CA/L=SF/O=Joyent/OU=Node.js/CN=agent3/emailAddress=ry@tinyclouds.org", "-multivalue-rdn", "-out", "o1.csr"]}, {"run": ["ca", "-batch", "-config", "o1.cnf", "-in", "o1.csr", "-out", "o1.crt", "-startdate", "20240827225844Z", "-enddate", "22980611225844Z", "-md", "sha256", "-preserveDN", "-notext", "-keyfile", "o0k.p8", "-cert", "o0.pem"]}, {"run": ["x509", "-in", "o1.crt", "-out", "o1.pem"]}, {"write": "o3.index", "content": "R\t491231235959Z\t181116184220Z\t91F006636069F29A\tunknown\t/CN=revoked\nR\t491231235959Z\t220903144651Z\t91F006636069F29E\tunknown\t/CN=revoked\nR\t491231235959Z\t240827225844Z\t783006FA8D75BD4E95045EE3EC02EE0609D042C2\tunknown\t/CN=revoked\n"}, {"write": "o3.cnf", "content": "[ca]\ndefault_ca = ca_o3\n[ca_o3]\ndir = .\ndatabase = ./o3.index\nnew_certs_dir = .\nserial = ./o3.serial\ndefault_md = sha512\npolicy = pol_any\nunique_subject = no\nemail_in_dn = yes\ncopy_extensions = none\n\n[pol_any]\ncountryName = optional\nstateOrProvinceName = optional\nlocalityName = optional\norganizationName = optional\norganizationalUnitName = optional\ncommonName = optional\nemailAddress = optional\n[ext]\n\n[req]\ndistinguished_name = dn\n[dn]\n"}, {"run": ["ca", "-batch", "-config", "o3.cnf", "-gencrl", "-keyfile", "o0k.p8", "-cert", "o0.pem", "-md", "sha512", "-crl_lastupdate", "20240827225844Z", "-crl_nextupdate", "20520112225844Z", "-out", "o3.pem"]}, {"write": "o4.index", "content": "R\t491231235959Z\t260416040352Z\t7B67075230D39AD32A32FE5DCFB1FA95E2EA319D\tunknown\t/CN=revoked\n"}, {"write": "o4.cnf", "content": "[ca]\ndefault_ca = ca_o4\n[ca_o4]\ndir = .\ndatabase = ./o4.index\nnew_certs_dir = .\nserial = ./o4.serial\ndefault_md = sha512\npolicy = pol_any\nunique_subject = no\nemail_in_dn = yes\ncopy_extensions = none\ncrlnumber = ./o4.crlnum\n[pol_any]\ncountryName = optional\nstateOrProvinceName = optional\nlocalityName = optional\norganizationName = optional\norganizationalUnitName = optional\ncommonName = optional\nemailAddress = optional\n[ext]\n\n[req]\ndistinguished_name = dn\n[dn]\n"}, {"write": "o4.crlnum", "content": "01\n"}, {"run": ["ca", "-batch", "-config", "o4.cnf", "-gencrl", "-keyfile", "o0k.p8", "-cert", "o0.pem", "-md", "sha512", "-crl_lastupdate", "20260416040352Z", "-crl_nextupdate", "20530901040352Z", "-out", "o4.pem"]}]) {
      if (s.write !== undefined) __fs.writeFileSync(__path.join(dir, s.write), s.content);
      else execFileSync('openssl', s.run, { cwd: dir, stdio: ['ignore', 'ignore', 'pipe'] });
    }
    const out = {};
    for (const n of ["o0", "o1", "o2", "o3", "o4"]) out[n] = __fs.readFileSync(__path.join(dir, n + '.pem'), 'utf8');
    process.env.REPRO_PEM = JSON.stringify(out);
    return out;
  } finally {
    __fs.rmSync(dir, { recursive: true, force: true });
  }
})();
const tls = require('tls');
const D = {"ca":__pem.o0,"cert":__pem.o1,"key":__pem.o2,"crl1":__pem.o3,"crl2":__pem.o4};
const crl = D.crl1 + D.crl2;
const server = tls.createServer({ cert: D.cert, key: D.key }, (s) => s.end());
server.on('tlsClientError', () => {});
server.listen(0, '127.0.0.1', () => {
  const c = tls.connect({ port: server.address().port, host: '127.0.0.1', servername: 'agent3', ca: D.ca, crl }, () => {
    console.log('connected (revoked cert accepted)');
    c.destroy(); server.close();
  });
  c.on('error', (e) => { console.log('error:', e.code); server.close(); });
});
