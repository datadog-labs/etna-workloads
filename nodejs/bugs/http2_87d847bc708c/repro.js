"use strict";
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
    for (const s of [{"run": ["genpkey", "-algorithm", "RSA", "-pkeyopt", "rsa_keygen_bits:2048", "-pkeyopt", "rsa_keygen_primes:2", "-out", "o0.p8"]}, {"run": ["pkey", "-in", "o0.p8", "-out", "o0.pem"]}, {"write": "o1.cnf", "content": "[ca]\ndefault_ca = ca_o1\n[ca_o1]\ndir = .\ndatabase = ./o1.index\nnew_certs_dir = .\nserial = ./o1.serial\ndefault_md = sha256\npolicy = pol_any\nunique_subject = no\nemail_in_dn = yes\ncopy_extensions = none\n\n[pol_any]\ncountryName = optional\nstateOrProvinceName = optional\nlocalityName = optional\norganizationName = optional\norganizationalUnitName = optional\ncommonName = optional\nemailAddress = optional\n[ext]\nsubjectKeyIdentifier=hash\nauthorityKeyIdentifier=keyid\n2.5.29.19=critical,DER:30030101FF\n[req]\ndistinguished_name = dn\n[dn]\n"}, {"write": "o1.index", "content": ""}, {"write": "o1.serial", "content": "60D072C31E96FBB1EF87F30688D4DCBBFA6B8D34\n"}, {"run": ["req", "-new", "-config", "o1.cnf", "-key", "o0.p8", "-subj", "/CN=localhost", "-multivalue-rdn", "-out", "o1.csr"]}, {"run": ["ca", "-batch", "-config", "o1.cnf", "-in", "o1.csr", "-out", "o1.crt", "-startdate", "20261105033552Z", "-enddate", "21261012033552Z", "-md", "sha256", "-preserveDN", "-notext", "-extensions", "ext", "-selfsign", "-keyfile", "o0.p8"]}, {"run": ["x509", "-in", "o1.crt", "-out", "o1.pem"]}]) {
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
const key = __pem.o0;
const cert = __pem.o1;
const server = http2.createSecureServer({ key, cert });
server.on("session", (s) => {
  s.on("error", () => {});
  s.on("connect", () => {
    for (let i = 0; i < 4; i++) {
      const o = [];
      for (let j = 0; j < 100; j++) o.push("https://o" + i + "-" + j + ".example");
      s.origin(...o);
    }
  });
});
server.listen(0, () => {
  const c = http2.connect("https://localhost:" + server.address().port, { ca: cert });
  let events = 0;
  c.on("origin", () => events++);
  c.on("error", (e) => console.log("client error:", e.code));
  c.on("close", () => {
    console.log("closed; origin events:", events, "originSet size:", c.originSet === undefined ? "n/a" : c.originSet.length);
    server.close();
  });
  setTimeout(() => {
    if (!c.destroyed) {
      console.log("still open; originSet size:", c.originSet.length);
      c.destroy();
    }
  }, 1500);
});
