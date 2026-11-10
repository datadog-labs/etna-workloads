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
    for (const s of [{"run": ["genpkey", "-algorithm", "RSA", "-pkeyopt", "rsa_keygen_bits:2048", "-pkeyopt", "rsa_keygen_primes:2", "-out", "o0.p8"]}, {"run": ["pkey", "-in", "o0.p8", "-traditional", "-out", "o0.pem"]}, {"write": "o1.cnf", "content": "[ca]\ndefault_ca = ca_o1\n[ca_o1]\ndir = .\ndatabase = ./o1.index\nnew_certs_dir = .\nserial = ./o1.serial\ndefault_md = sha256\npolicy = pol_any\nunique_subject = no\nemail_in_dn = yes\ncopy_extensions = none\n\n[pol_any]\ncountryName = optional\nstateOrProvinceName = optional\nlocalityName = optional\norganizationName = optional\norganizationalUnitName = optional\ncommonName = optional\nemailAddress = optional\n[ext]\n2.5.29.15=DER:030205A0\n2.5.29.37=DER:300A06082B06010505070301\n2.5.29.17=DER:301C82093132372E302E302E3182096C6F63616C686F737487047F000001\n[req]\ndistinguished_name = dn\n[dn]\n"}, {"write": "o1.index", "content": ""}, {"write": "o1.serial", "content": "6F7D8C69B9704F35498775105F076E9FDA41A05D\n"}, {"run": ["req", "-new", "-config", "o1.cnf", "-key", "o0.p8", "-subj", "/CN=localhost", "-multivalue-rdn", "-out", "o1.csr"]}, {"run": ["ca", "-batch", "-config", "o1.cnf", "-in", "o1.csr", "-out", "o1.crt", "-startdate", "20220315163408Z", "-enddate", "20320312163408Z", "-md", "sha256", "-preserveDN", "-notext", "-extensions", "ext", "-selfsign", "-keyfile", "o0.p8"]}, {"run": ["x509", "-in", "o1.crt", "-out", "o1.pem"]}]) {
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
const { spawnSync } = require('child_process');
const KEY = `
${__pem.o0}
`;
const CERT = `
${__pem.o1}
`;
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, [__filename, 'child'], { timeout: 10000, encoding: 'utf8' });
  console.log('child stdout:', r.stdout.trim());
  console.log('completed:', r.status === 0 && !r.signal);
  process.exit(0);
}
const https = require('https');
const server = https.createServer({ key: KEY, cert: CERT }, (req, res) => res.end('hello'));
server.listen(0, () => {
  const req = https.request({ hostname: '127.0.0.1', port: server.address().port, ca: CERT }, (res) => {
    console.log('status', res.statusCode);
    res.resume();
    server.close();
  });
  req.on('error', (e) => { console.log('error', e.code); server.close(); });
  req.end();
});
