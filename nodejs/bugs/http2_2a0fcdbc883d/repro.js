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
    for (const s of [{"run": ["genpkey", "-algorithm", "RSA", "-pkeyopt", "rsa_keygen_bits:2048", "-pkeyopt", "rsa_keygen_primes:2", "-out", "o0.p8"]}, {"run": ["pkey", "-in", "o0.p8", "-traditional", "-out", "o0.pem"]}, {"run": ["genpkey", "-algorithm", "RSA", "-pkeyopt", "rsa_keygen_bits:2048", "-pkeyopt", "rsa_keygen_primes:2", "-out", "ca0k.p8"]}, {"run": ["pkey", "-in", "ca0k.p8", "-out", "ca0k.pem"]}, {"write": "ca0.cnf", "content": "[ca]\ndefault_ca = ca_ca0\n[ca_ca0]\ndir = .\ndatabase = ./ca0.index\nnew_certs_dir = .\nserial = ./ca0.serial\ndefault_md = sha256\npolicy = pol_any\nunique_subject = no\nemail_in_dn = yes\ncopy_extensions = none\n\n[pol_any]\ncountryName = optional\nstateOrProvinceName = optional\nlocalityName = optional\norganizationName = optional\norganizationalUnitName = optional\ncommonName = optional\nemailAddress = optional\n[ext]\nbasicConstraints=critical,CA:TRUE\nkeyUsage=keyCertSign,cRLSign\n[req]\ndistinguished_name = dn\n[dn]\n"}, {"write": "ca0.index", "content": ""}, {"write": "ca0.serial", "content": "01\n"}, {"run": ["req", "-new", "-config", "ca0.cnf", "-key", "ca0k.p8", "-subj", "/C=US/ST=CA/L=SF/O=Joyent/OU=Node.js/CN=ca1/emailAddress=ry@tinyclouds.org", "-multivalue-rdn", "-out", "ca0.csr"]}, {"run": ["ca", "-batch", "-config", "ca0.cnf", "-in", "ca0.csr", "-out", "ca0.crt", "-startdate", "20000101000000Z", "-enddate", "29991231235959Z", "-md", "sha256", "-preserveDN", "-notext", "-extensions", "ext", "-selfsign", "-keyfile", "ca0k.p8"]}, {"run": ["x509", "-in", "ca0.crt", "-out", "ca0.pem"]}, {"write": "o1.cnf", "content": "[ca]\ndefault_ca = ca_o1\n[ca_o1]\ndir = .\ndatabase = ./o1.index\nnew_certs_dir = .\nserial = ./o1.serial\ndefault_md = sha256\npolicy = pol_any\nunique_subject = no\nemail_in_dn = yes\ncopy_extensions = none\n\n[pol_any]\ncountryName = optional\nstateOrProvinceName = optional\nlocalityName = optional\norganizationName = optional\norganizationalUnitName = optional\ncommonName = optional\nemailAddress = optional\n[ext]\n1.3.6.1.5.5.7.1.1=DER:304F302306082B060105050730018617687474703A2F2F6F6373702E6E6F64656A732E6F72672F302806082B06010505073002861C687474703A2F2F63612E6E6F64656A732E6F72672F63612E63657274\n[req]\ndistinguished_name = dn\n[dn]\n"}, {"write": "o1.index", "content": ""}, {"write": "o1.serial", "content": "147D36C1C2F74206DE9FAB5F2226D78ADB00A426\n"}, {"run": ["req", "-new", "-config", "o1.cnf", "-key", "o0.p8", "-subj", "/C=US/ST=CA/L=SF/O=Joyent/OU=Node.js/CN=agent1/emailAddress=ry@tinyclouds.org", "-multivalue-rdn", "-out", "o1.csr"]}, {"run": ["ca", "-batch", "-config", "o1.cnf", "-in", "o1.csr", "-out", "o1.crt", "-startdate", "20220903214037Z", "-enddate", "22960617214037Z", "-md", "sha256", "-preserveDN", "-notext", "-extensions", "ext", "-keyfile", "ca0k.p8", "-cert", "ca0.pem"]}, {"run": ["x509", "-in", "o1.crt", "-out", "o1.pem"]}]) {
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
const http2 = require("http2");
const tls = require("tls");
const key = __pem.o0;
const cert = __pem.o1;
const server = http2.createSecureServer({ key, cert, allowHTTP1: true });
server.on("request", (req, res) => { res.end("request"); });
server.on("upgrade", (req, socket) => {
  socket.end("HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\n\r\n");
});
server.listen(0, () => {
  const c = tls.connect({ port: server.address().port, rejectUnauthorized: false, ALPNProtocols: ["http/1.1"] }, () => {
    c.write("GET / HTTP/1.1\r\nHost: x\r\nConnection: Upgrade\r\nUpgrade: websocket\r\n\r\n");
  });
  let d = "";
  c.on("data", (b) => d += b);
  c.on("error", () => {});
  c.on("close", () => {
    console.log(d.split("\r\n")[0]);
    server.close();
  });
});
