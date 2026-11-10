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
    for (const s of [{"run": ["genpkey", "-algorithm", "RSA", "-pkeyopt", "rsa_keygen_bits:2048", "-pkeyopt", "rsa_keygen_primes:2", "-out", "o0.p8"]}, {"run": ["pkey", "-in", "o0.p8", "-traditional", "-out", "o0.pem"]}, {"write": "o1.cnf", "content": "[ca]\ndefault_ca = ca_o1\n[ca_o1]\ndir = .\ndatabase = ./o1.index\nnew_certs_dir = .\nserial = ./o1.serial\ndefault_md = sha512\npolicy = pol_any\nunique_subject = no\nemail_in_dn = yes\ncopy_extensions = none\n\n[pol_any]\ncountryName = optional\nstateOrProvinceName = optional\nlocalityName = optional\norganizationName = optional\norganizationalUnitName = optional\ncommonName = optional\nemailAddress = optional\n[ext]\n2.5.29.17=DER:300E970C2A2E6C6F63616C2E686F7374\n[req]\ndistinguished_name = dn\n[dn]\n"}, {"write": "o1.index", "content": ""}, {"write": "o1.serial", "content": "010001\n"}, {"run": ["req", "-new", "-config", "o1.cnf", "-key", "o0.p8", "-subj", "/CN=local.host", "-multivalue-rdn", "-out", "o1.csr"]}, {"run": ["ca", "-batch", "-config", "o1.cnf", "-in", "o1.csr", "-out", "o1.crt", "-startdate", "20191205042833Z", "-enddate", "20441129042833Z", "-md", "sha512", "-preserveDN", "-notext", "-extensions", "ext", "-selfsign", "-keyfile", "o0.p8"]}, {"run": ["x509", "-in", "o1.crt", "-out", "o1.pem"]}]) {
      if (s.write !== undefined) __fs.writeFileSync(__path.join(dir, s.write), s.content);
      else execFileSync('openssl', s.run, { cwd: dir, stdio: ['ignore', 'ignore', 'pipe'] });
    }
    const out = {};
    for (const n of ["o0", "o1"]) out[n] = __fs.readFileSync(__path.join(dir, n + '.pem'), 'utf8');
    process.env.REPRO_PEM = JSON.stringify(out);
    return out;
  } finally {
    __fs.rmSync(dir, { recursive: true, force: true });
  }
})();
const tls = require('tls');
const pem = `${__pem.o0}
${__pem.o1}
`;
if (process.argv[2] !== 'child') {
  const r = require('child_process').spawnSync(process.execPath, [__filename, 'child'], { encoding: 'utf8' });
  console.log('child exited ok:', r.status === 0 && r.signal === null);
  console.log(r.stdout.trim());
} else {
  const server = tls.createServer({ key: pem, cert: pem }, (s) => s.end());
  server.listen(0, () => {
    const client = tls.connect({ port: server.address().port, rejectUnauthorized: false }, () => {
      console.log('subjectaltname:', client.getPeerCertificate().subjectaltname);
      server.close(); client.end();
    });
  });
}
