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
    for (const s of [{"run": ["genpkey", "-algorithm", "RSA", "-pkeyopt", "rsa_keygen_bits:2048", "-pkeyopt", "rsa_keygen_primes:2", "-out", "o0.p8"]}, {"run": ["pkey", "-in", "o0.p8", "-traditional", "-out", "o0.pem"]}, {"run": ["genpkey", "-algorithm", "RSA", "-pkeyopt", "rsa_keygen_bits:2048", "-pkeyopt", "rsa_keygen_primes:2", "-out", "o2.p8"]}, {"run": ["pkey", "-in", "o2.p8", "-traditional", "-out", "o2.pem"]}, {"run": ["genpkey", "-algorithm", "RSA", "-pkeyopt", "rsa_keygen_bits:2048", "-pkeyopt", "rsa_keygen_primes:2", "-out", "ca0k.p8"]}, {"run": ["pkey", "-in", "ca0k.p8", "-out", "ca0k.pem"]}, {"write": "ca0.cnf", "content": "[ca]\ndefault_ca = ca_ca0\n[ca_ca0]\ndir = .\ndatabase = ./ca0.index\nnew_certs_dir = .\nserial = ./ca0.serial\ndefault_md = sha256\npolicy = pol_any\nunique_subject = no\nemail_in_dn = yes\ncopy_extensions = none\n\n[pol_any]\ncountryName = optional\nstateOrProvinceName = optional\nlocalityName = optional\norganizationName = optional\norganizationalUnitName = optional\ncommonName = optional\nemailAddress = optional\n[ext]\nbasicConstraints=critical,CA:TRUE\nkeyUsage=keyCertSign,cRLSign\n[req]\ndistinguished_name = dn\n[dn]\n"}, {"write": "ca0.index", "content": ""}, {"write": "ca0.serial", "content": "01\n"}, {"run": ["req", "-new", "-config", "ca0.cnf", "-key", "ca0k.p8", "-subj", "/C=US/ST=CA/L=SF/O=Joyent/OU=Node.js/CN=ca1/emailAddress=ry@tinyclouds.org", "-multivalue-rdn", "-out", "ca0.csr"]}, {"run": ["ca", "-batch", "-config", "ca0.cnf", "-in", "ca0.csr", "-out", "ca0.crt", "-startdate", "20000101000000Z", "-enddate", "29991231235959Z", "-md", "sha256", "-preserveDN", "-notext", "-extensions", "ext", "-selfsign", "-keyfile", "ca0k.p8"]}, {"run": ["x509", "-in", "ca0.crt", "-out", "ca0.pem"]}, {"write": "o1.cnf", "content": "[ca]\ndefault_ca = ca_o1\n[ca_o1]\ndir = .\ndatabase = ./o1.index\nnew_certs_dir = .\nserial = ./o1.serial\ndefault_md = sha256\npolicy = pol_any\nunique_subject = no\nemail_in_dn = yes\ncopy_extensions = none\n\n[pol_any]\ncountryName = optional\nstateOrProvinceName = optional\nlocalityName = optional\norganizationName = optional\norganizationalUnitName = optional\ncommonName = optional\nemailAddress = optional\n[ext]\n1.3.6.1.5.5.7.1.1=DER:304F302306082B060105050730018617687474703A2F2F6F6373702E6E6F64656A732E6F72672F302806082B06010505073002861C687474703A2F2F63612E6E6F64656A732E6F72672F63612E63657274\n[req]\ndistinguished_name = dn\n[dn]\n"}, {"write": "o1.index", "content": ""}, {"write": "o1.serial", "content": "147D36C1C2F74206DE9FAB5F2226D78ADB00A426\n"}, {"run": ["req", "-new", "-config", "o1.cnf", "-key", "o0.p8", "-subj", "/C=US/ST=CA/L=SF/O=Joyent/OU=Node.js/CN=agent1/emailAddress=ry@tinyclouds.org", "-multivalue-rdn", "-out", "o1.csr"]}, {"run": ["ca", "-batch", "-config", "o1.cnf", "-in", "o1.csr", "-out", "o1.crt", "-startdate", "20220903214037Z", "-enddate", "22960617214037Z", "-md", "sha256", "-preserveDN", "-notext", "-extensions", "ext", "-keyfile", "ca0k.p8", "-cert", "ca0.pem"]}, {"run": ["x509", "-in", "o1.crt", "-out", "o1.pem"]}, {"write": "o3.cnf", "content": "[ca]\ndefault_ca = ca_o3\n[ca_o3]\ndir = .\ndatabase = ./o3.index\nnew_certs_dir = .\nserial = ./o3.serial\ndefault_md = sha256\npolicy = pol_any\nunique_subject = no\nemail_in_dn = yes\ncopy_extensions = none\n\n[pol_any]\ncountryName = optional\nstateOrProvinceName = optional\nlocalityName = optional\norganizationName = optional\norganizationalUnitName = optional\ncommonName = optional\nemailAddress = optional\n[ext]\n\n[req]\ndistinguished_name = dn\n[dn]\n"}, {"write": "o3.index", "content": ""}, {"write": "o3.serial", "content": "5DDCAA152C0582CD8776C255AB4437165CA18EEB\n"}, {"run": ["req", "-new", "-config", "o3.cnf", "-key", "o2.p8", "-subj", "/C=US/ST=CA/L=SF/O=Joyent/OU=Node.js/CN=agent2/emailAddress=ry@tinyclouds.org", "-multivalue-rdn", "-out", "o3.csr"]}, {"run": ["ca", "-batch", "-config", "o3.cnf", "-in", "o3.csr", "-out", "o3.crt", "-startdate", "20220903144651Z", "-enddate", "22960617144651Z", "-md", "sha256", "-preserveDN", "-notext", "-selfsign", "-keyfile", "o2.p8"]}, {"run": ["x509", "-in", "o3.crt", "-out", "o3.pem"]}]) {
      if (s.write !== undefined) __fs.writeFileSync(__path.join(dir, s.write), s.content);
      else execFileSync('openssl', s.run, { cwd: dir, stdio: ['ignore', 'ignore', 'pipe'] });
    }
    const out = {};
    for (const n of ["o0", "o1", "o2", "o3"]) out[n] = __fs.readFileSync(__path.join(dir, n + '.pem'), 'utf8');
    process.env.REPRO_PEM = JSON.stringify(out);
    return out;
  } finally {
    __fs.rmSync(dir, { recursive: true, force: true });
  }
})();
const tls = require('tls');
const agent1key = `${__pem.o0}`;
const agent1cert = `${__pem.o1}`;
const agent2key = `${__pem.o2}`;
const agent2cert = `${__pem.o3}`;
const server = tls.createServer({ key: agent2key, cert: agent2cert }, (c) => c.end());
server.addContext('a.example.com', { key: agent1key, cert: agent1cert });
server.listen(0, '127.0.0.1', () => {
  const names = ['a.example.com', 'A.EXAMPLE.COM'];
  let i = 0;
  const next = () => {
    if (i === names.length) { server.close(); return; }
    const servername = names[i++];
    const s = tls.connect({ port: server.address().port, host: '127.0.0.1',
                            servername, rejectUnauthorized: false }, () => {
      console.log(servername, '->', s.getPeerCertificate().subject.CN);
      s.end();
    });
    s.on('close', next);
    s.on('error', (e) => console.log('error', e.code));
  };
  next();
});
