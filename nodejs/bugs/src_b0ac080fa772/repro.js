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
    for (const s of [{"run": ["genpkey", "-algorithm", "EC", "-pkeyopt", "ec_paramgen_curve:prime256v1", "-pkeyopt", "ec_param_enc:named_curve", "-out", "o1.p8"]}, {"run": ["pkey", "-in", "o1.p8", "-traditional", "-out", "o1.pem"]}, {"run": ["ecparam", "-name", "prime256v1", "-out", "o0.pem"]}, {"write": "o2.cnf", "content": "[ca]\ndefault_ca = ca_o2\n[ca_o2]\ndir = .\ndatabase = ./o2.index\nnew_certs_dir = .\nserial = ./o2.serial\ndefault_md = sha256\npolicy = pol_any\nunique_subject = no\nemail_in_dn = yes\ncopy_extensions = none\n\n[pol_any]\ncountryName = optional\nstateOrProvinceName = optional\nlocalityName = optional\norganizationName = optional\norganizationalUnitName = optional\ncommonName = optional\nemailAddress = optional\n[ext]\n\n[req]\ndistinguished_name = dn\n[dn]\n"}, {"write": "o2.index", "content": ""}, {"write": "o2.serial", "content": "3254D6D0A8F3C35853FFE913E0D028EF61503B05\n"}, {"run": ["req", "-new", "-config", "o2.cnf", "-key", "o1.p8", "-subj", "/C=AU/ST=Some-State/O=Internet Widgits Pty Ltd", "-multivalue-rdn", "-out", "o2.csr"]}, {"run": ["ca", "-batch", "-config", "o2.cnf", "-in", "o2.csr", "-out", "o2.crt", "-startdate", "20200922085459Z", "-enddate", "20480207085459Z", "-md", "sha256", "-preserveDN", "-notext", "-selfsign", "-keyfile", "o1.p8"]}, {"run": ["x509", "-in", "o2.crt", "-out", "o2.pem"]}]) {
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
// Reproducer for CVE-2020-8265: use-after-free of WriteWrap/ShutdownWrap
// when a TLS write req is synchronously destroyed during DoWrite().
//
// Writing to a TLS socket multiple times back-to-back, then destroying the
// socket as soon as any data arrives, can synchronously tear down the
// in-flight write wrap while TLSWrap::DoWrite() is still using it. Without
// the fix (retaining a BaseObjectPtr to the wrap's AsyncWrap across the
// DoWrite() call), the wrap can be freed and reused/corrupted before
// DoWrite() finishes with it, leading to a use-after-free / crash.
//
// On a fixed binary this prints "done" and exits 0.
// On the buggy binary this crashes (SIGABRT from an internal assertion, or
// a use-after-free) with a non-zero exit status.

const https = require('https');
const tls = require('tls');

const kMessage =
  'GET / HTTP/1.1\r\nHost: localhost\r\nConnection: Keep-alive\r\n\r\n';

const key = `${__pem.o0}
${__pem.o1}`;

const cert = `${__pem.o2}`;

const server = https.createServer(
  { key, cert },
  (req, res) => {
    res.writeHead(200);
    res.end('boom goes the dynamite\n');
  });

server.listen(0, () => {
  const socket =
    tls.connect(
      server.address().port,
      'localhost',
      { rejectUnauthorized: false },
      () => {
        socket.write(kMessage);
        socket.write(kMessage);
        socket.write(kMessage);
      });

  socket.on('data', () => socket.destroy());
  socket.on('close', () => {
    setImmediate(() => server.close());
  });
});

process.on('exit', () => console.log('done'));
