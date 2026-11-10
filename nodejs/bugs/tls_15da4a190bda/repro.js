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
    for (const s of [{"run": ["genpkey", "-algorithm", "RSA", "-pkeyopt", "rsa_keygen_bits:2048", "-pkeyopt", "rsa_keygen_primes:2", "-out", "o1.p8"]}, {"run": ["pkey", "-in", "o1.p8", "-traditional", "-out", "o1.pem"]}, {"run": ["genpkey", "-algorithm", "RSA", "-pkeyopt", "rsa_keygen_bits:2048", "-pkeyopt", "rsa_keygen_primes:2", "-out", "o0k.p8"]}, {"run": ["pkey", "-in", "o0k.p8", "-out", "o0k.pem"]}, {"write": "o0.cnf", "content": "[ca]\ndefault_ca = ca_o0\n[ca_o0]\ndir = .\ndatabase = ./o0.index\nnew_certs_dir = .\nserial = ./o0.serial\ndefault_md = sha256\npolicy = pol_any\nunique_subject = no\nemail_in_dn = yes\ncopy_extensions = none\n\n[pol_any]\ncountryName = optional\nstateOrProvinceName = optional\nlocalityName = optional\norganizationName = optional\norganizationalUnitName = optional\ncommonName = optional\nemailAddress = optional\n[ext]\n2.5.29.19=DER:30030101FF\n[req]\ndistinguished_name = dn\n[dn]\n"}, {"write": "o0.index", "content": ""}, {"write": "o0.serial", "content": "4AB16C8DFD6A7D0D2DFCABDF9C4B0E92C6AD0229\n"}, {"run": ["req", "-new", "-config", "o0.cnf", "-key", "o0k.p8", "-subj", "/C=US/ST=CA/L=SF/O=Joyent/OU=Node.js/CN=ca1/emailAddress=ry@tinyclouds.org", "-multivalue-rdn", "-out", "o0.csr"]}, {"run": ["ca", "-batch", "-config", "o0.cnf", "-in", "o0.csr", "-out", "o0.crt", "-startdate", "20220903214037Z", "-enddate", "22960617214037Z", "-md", "sha256", "-preserveDN", "-notext", "-extensions", "ext", "-selfsign", "-keyfile", "o0k.p8"]}, {"run": ["x509", "-in", "o0.crt", "-out", "o0.pem"]}, {"write": "o2.cnf", "content": "[ca]\ndefault_ca = ca_o2\n[ca_o2]\ndir = .\ndatabase = ./o2.index\nnew_certs_dir = .\nserial = ./o2.serial\ndefault_md = sha256\npolicy = pol_any\nunique_subject = no\nemail_in_dn = yes\ncopy_extensions = none\n\n[pol_any]\ncountryName = optional\nstateOrProvinceName = optional\nlocalityName = optional\norganizationName = optional\norganizationalUnitName = optional\ncommonName = optional\nemailAddress = optional\n[ext]\n\n[req]\ndistinguished_name = dn\n[dn]\n"}, {"write": "o2.index", "content": ""}, {"write": "o2.serial", "content": "5DDCAA152C0582CD8776C255AB4437165CA18EEB\n"}, {"run": ["req", "-new", "-config", "o2.cnf", "-key", "o1.p8", "-subj", "/C=US/ST=CA/L=SF/O=Joyent/OU=Node.js/CN=agent2/emailAddress=ry@tinyclouds.org", "-multivalue-rdn", "-out", "o2.csr"]}, {"run": ["ca", "-batch", "-config", "o2.cnf", "-in", "o2.csr", "-out", "o2.crt", "-startdate", "20220903144651Z", "-enddate", "22960617144651Z", "-md", "sha256", "-preserveDN", "-notext", "-selfsign", "-keyfile", "o1.p8"]}, {"run": ["x509", "-in", "o2.crt", "-out", "o2.pem"]}]) {
      if (s.write !== undefined) __fs.writeFileSync(__path.join(dir, s.write), s.content);
      else execFileSync('openssl', s.run, { cwd: dir, stdio: ['ignore', 'ignore', 'pipe'] });
    }
    const out = {};
    for (const n of ["o0", "o1", "o2"]) out[n] = __fs.readFileSync(__path.join(dir, n + '.pem'), 'utf8');
    process.env.REPRO_PEM = JSON.stringify(out);
    return out;
  } finally {
    __fs.rmSync(dir, { recursive: true, force: true });
  }
})();
const tls = require('tls');
const ca1cert = `${__pem.o0}`;
const agent2key = `${__pem.o1}`;
const agent2cert = `${__pem.o2}`;
let n = 0;
const server = tls.createServer({ key: agent2key, cert: agent2cert, ca: ca1cert,
  requestCert: true, rejectUnauthorized: false, minVersion: 'TLSv1.3', maxVersion: 'TLSv1.3' }, (s) => {
  console.log(`conn ${n++} reused=${s.isSessionReused()} authorized=${s.authorized} err=${s.authorizationError}`);
  s.end('.');
});
function hs(opts) {
  return new Promise((res) => {
    const c = tls.connect(opts);
    let sess;
    c.on('session', (s) => { sess = s; });
    c.resume();
    c.on('close', () => res(sess));
    c.on('secureConnect', () => setTimeout(() => c.end(), 100));
  });
}
server.listen(0, async () => {
  const o = { port: server.address().port, host: '127.0.0.1', rejectUnauthorized: false,
    minVersion: 'TLSv1.3', maxVersion: 'TLSv1.3' };
  const s = await hs(o);
  await hs({ ...o, session: s });
  server.close();
});
