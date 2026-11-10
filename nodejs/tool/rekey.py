#!/usr/bin/env python3
"""Replace PEM key/certificate/CRL literals embedded in a reproducer with runtime generation.

Secret scanners flag literal "PRIVATE KEY" blocks even when they are throwaway test keys.
For each embedded object this builds an equivalent openssl recipe that keeps what a bug
can depend on: key algorithm, size, prime count and encoding (PKCS#1 / PKCS#8 / SEC1);
certificate subject DN (order and multi-valued fields kept), issuer chain, serial,
validity dates, extensions (SAN, basicConstraints, keyUsage, extendedKeyUsage) and
signature digest; CRL issuer, version, CRL number, dates and revoked serials.

The recipe is emitted as a prelude in the reproducer: at start-up it runs the openssl CLI
in a fresh fs.mkdtempSync() directory, reads the results into `__pem`, deletes the
directory, and every former literal is replaced by the corresponding `__pem.<name>`.

  rekey.py <in repro.js> <out repro.js>
"""
import json, re, subprocess, sys

PEM = re.compile(r"-----BEGIN ([A-Z0-9 ]+)-----(?:\\n|\s|[\"'+`,])*(.*?)-----END \1-----", re.S)
MONTHS = {m: i + 1 for i, m in enumerate("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec".split())}
KU = {"Digital Signature": "digitalSignature", "Non Repudiation": "nonRepudiation",
      "Content Commitment": "nonRepudiation", "Key Encipherment": "keyEncipherment",
      "Data Encipherment": "dataEncipherment", "Key Agreement": "keyAgreement",
      "Certificate Sign": "keyCertSign", "CRL Sign": "cRLSign", "Encipher Only": "encipherOnly",
      "Decipher Only": "decipherOnly"}
EKU = {"TLS Web Server Authentication": "serverAuth", "TLS Web Client Authentication": "clientAuth",
       "Code Signing": "codeSigning", "E-mail Protection": "emailProtection",
       "Time Stamping": "timeStamping", "OCSP Signing": "OCSPSigning"}


def ossl(args, inp):
    p = subprocess.run(["openssl", *args], input=inp, capture_output=True, text=True)
    if p.returncode:
        raise RuntimeError(f"openssl {' '.join(args)}: {p.stderr[:300]}")
    return p.stdout


def norm_pem(kind, body):
    b64 = re.sub(r"\\n|[^A-Za-z0-9+/=]", "", body)
    return f"-----BEGIN {kind}-----\n" + "\n".join(b64[i:i + 64] for i in range(0, len(b64), 64)) + \
        f"\n-----END {kind}-----\n"


def gentime(s):
    """'Sep  3 21:40:37 2022 GMT' -> '20220903214037Z'"""
    m = re.match(r"(\w{3})\s+(\d+) (\d\d):(\d\d):(\d\d) (\d{4}) GMT", s.strip())
    mo, d, H, M, S, Y = m.groups()
    return f"{Y}{MONTHS[mo]:02d}{int(d):02d}{H}{M}{S}Z"


def index_time(g):
    """openssl ca index: UTCTime (YYMMDDHHMMSSZ) for years < 2050, else GeneralizedTime."""
    return g[2:] if int(g[:4]) < 2050 else g


def dn_subj(dn_rfc2253):
    """RFC2253 (reversed, escaped) -> openssl -subj '/C=../ST=..' in original order."""
    parts, cur, esc = [], "", False
    for ch in dn_rfc2253:
        if esc:
            cur += ch; esc = False
        elif ch == "\\":
            esc = True
        elif ch == ",":
            parts.append(cur); cur = ""
        else:
            cur += ch
    parts.append(cur)
    return "".join("/" + p.replace("/", "\\/") for p in reversed([p for p in parts if p]))


def sig_md(txt):
    """'sha256WithRSAEncryption' / 'ecdsa-with-SHA256' -> 'sha256'."""
    alg = re.search(r"Signature Algorithm: (\S+)", txt).group(1)
    m = re.search(r"(sha\d+|md5|sha1)", alg, re.I)
    return m.group(1).lower() if m else "sha256"


EXT_OID = {"X509v3 Subject Alternative Name": "2.5.29.17", "X509v3 Basic Constraints": "2.5.29.19",
           "X509v3 Key Usage": "2.5.29.15", "X509v3 Extended Key Usage": "2.5.29.37",
           "X509v3 Subject Key Identifier": "2.5.29.14", "X509v3 Authority Key Identifier": "2.5.29.35",
           "X509v3 CRL Distribution Points": "2.5.29.31", "X509v3 Certificate Policies": "2.5.29.32",
           "X509v3 Issuer Alternative Name": "2.5.29.18", "X509v3 Name Constraints": "2.5.29.30",
           "Authority Information Access": "1.3.6.1.5.5.7.1.1", "Netscape Comment": "2.16.840.1.113730.1.13",
           "Netscape Cert Type": "2.16.840.1.113730.1.1", "CT Precertificate SCTs": "1.3.6.1.4.1.11129.2.4.2"}


def der_extensions(pem):
    """Every certificate extension copied byte for byte (`<oid>=[critical,]DER:<hex>`), except the
    key identifiers, which depend on the (new) keys and are regenerated."""
    lines = ossl(["asn1parse", "-i"], pem).splitlines()
    out = []
    for i, line in enumerate(lines):
        m = re.search(r"prim:\s+OBJECT\s+:(.+)$", line)
        if not m:
            continue
        name = m.group(1).strip()
        oid = EXT_OID.get(name, name if re.fullmatch(r"[\d.]+", name) else None)
        if oid is None:
            continue  # an algorithm/DN OID, not an extension
        crit, j = False, i + 1
        if j < len(lines) and "BOOLEAN" in lines[j]:
            crit = "255" in lines[j] or "TRUE" in lines[j].upper(); j += 1
        if j >= len(lines) or "OCTET STRING" not in lines[j]:
            continue
        hx = lines[j].split("[HEX DUMP]:")[-1].strip() if "[HEX DUMP]" in lines[j] else None
        if oid == "2.5.29.14":
            out.append("subjectKeyIdentifier=hash"); continue
        if oid == "2.5.29.35":
            out.append("authorityKeyIdentifier=keyid"); continue
        if hx is None:
            raise RuntimeError(f"extension {name}: no DER dump")
        out.append(f"{oid}={'critical,' if crit else ''}DER:{hx}")
    return out


def key_spec(pem):
    txt = ossl(["pkey", "-noout", "-text"], pem)
    if "Private-Key:" in txt and ("modulus" in txt or "prime1" in txt):
        bits = int(re.search(r"\((\d+) bit", txt).group(1))
        primes = int(re.search(r"(\d+) primes", txt).group(1)) if "primes" in txt else 2
        return {"alg": "RSA", "bits": bits, "primes": primes}
    m = re.search(r"NIST CURVE: (\S+)|ASN1 OID: (\S+)", txt)
    if m:
        return {"alg": "EC", "curve": m.group(2) or {"P-256": "prime256v1", "P-384": "secp384r1"}[m.group(1)]}
    if txt.startswith("ED25519") or "ED25519" in txt[:40]:
        return {"alg": "ED25519"}
    raise RuntimeError("unsupported key: " + txt[:80])


def pub_of_key(pem):
    return ossl(["pkey", "-pubout"], pem)


def plan(js):
    objs = []
    for m in PEM.finditer(js):
        kind = m.group(1)
        objs.append({"kind": kind, "pem": norm_pem(kind, m.group(2)), "start": m.start(), "end": m.end()})
    keys, certs, crls, params = [], [], [], []
    for i, o in enumerate(objs):
        o["name"] = f"o{i}"
        if "PRIVATE KEY" in o["kind"]:
            o["spec"] = key_spec(o["pem"]); o["pub"] = pub_of_key(o["pem"]); keys.append(o)
        elif o["kind"] == "CERTIFICATE":
            certs.append(o)
        elif o["kind"] == "X509 CRL":
            crls.append(o)
        elif o["kind"] == "EC PARAMETERS":
            params.append(o)
        else:
            raise RuntimeError("unsupported PEM kind " + o["kind"])
    for c in certs:
        p = c["pem"]
        c["subj"] = dn_subj(ossl(["x509", "-noout", "-subject", "-nameopt", "RFC2253"], p).split("=", 1)[1].strip())
        c["issuer"] = dn_subj(ossl(["x509", "-noout", "-issuer", "-nameopt", "RFC2253"], p).split("=", 1)[1].strip())
        c["serial"] = ossl(["x509", "-noout", "-serial"], p).split("=", 1)[1].strip()
        d = ossl(["x509", "-noout", "-dates"], p)
        c["nb"] = gentime(re.search(r"notBefore=(.*)", d).group(1))
        c["na"] = gentime(re.search(r"notAfter=(.*)", d).group(1))
        txt = ossl(["x509", "-noout", "-text"], p)
        c["md"] = sig_md(txt)
        ext = der_extensions(p)
        c["ext"] = ext
        c["v1"] = "Version: 1 (0x0)" in txt
        pub = ossl(["x509", "-noout", "-pubkey"], p)
        c["key"] = next((k["name"] for k in keys if k["pub"] == pub), None)
        if not c["key"]:
            c["keyspec"] = key_spec_from_pub(pub)
    for r in crls:
        txt = ossl(["crl", "-noout", "-text", "-nameopt", "RFC2253"], r["pem"])
        r["issuer"] = dn_subj(re.search(r"Issuer: (.*)", txt).group(1).strip())
        r["last"] = gentime(re.search(r"Last Update: (.*)", txt).group(1))
        r["next"] = gentime(re.search(r"Next Update: (.*)", txt).group(1))
        r["md"] = sig_md(txt)
        m = re.search(r"X509v3 CRL Number:\s*\n\s*(\d+)", txt)
        r["crlnum"] = int(m.group(1)) if m else None
        r["revoked"] = re.findall(r"Serial Number: (\w+)\s*\n\s*Revocation Date: (.*)", txt)
    return objs, keys, certs, crls, params


def key_spec_from_pub(pub):
    txt = ossl(["pkey", "-pubin", "-noout", "-text"], pub)
    if "Modulus" in txt or "RSA" in txt[:30]:
        return {"alg": "RSA", "bits": int(re.search(r"\((\d+) bit", txt).group(1)), "primes": 2}
    m = re.search(r"ASN1 OID: (\S+)", txt)
    return {"alg": "EC", "curve": m.group(1)}


def keygen_steps(name, spec, kind):
    """Steps producing <name>.pem in the encoding of `kind`."""
    if spec["alg"] == "RSA":
        gen = ["genpkey", "-algorithm", "RSA", "-pkeyopt", f"rsa_keygen_bits:{spec['bits']}",
               "-pkeyopt", f"rsa_keygen_primes:{spec['primes']}", "-out", f"{name}.p8"]
    elif spec["alg"] == "EC":
        gen = ["genpkey", "-algorithm", "EC", "-pkeyopt", f"ec_paramgen_curve:{spec['curve']}",
               "-pkeyopt", "ec_param_enc:named_curve", "-out", f"{name}.p8"]
    else:
        gen = ["genpkey", "-algorithm", "ED25519", "-out", f"{name}.p8"]
    steps = [{"run": gen}]
    if kind in ("RSA PRIVATE KEY", "EC PRIVATE KEY"):
        steps.append({"run": ["pkey", "-in", f"{name}.p8", "-traditional", "-out", f"{name}.pem"]})
    else:
        steps.append({"run": ["pkey", "-in", f"{name}.p8", "-out", f"{name}.pem"]})
    return steps


CA_CONF = """[ca]
default_ca = ca_{id}
[ca_{id}]
dir = .
database = ./{id}.index
new_certs_dir = .
serial = ./{id}.serial
default_md = {md}
policy = pol_any
unique_subject = no
email_in_dn = yes
copy_extensions = none
{crlnum}
[pol_any]
countryName = optional
stateOrProvinceName = optional
localityName = optional
organizationName = optional
organizationalUnitName = optional
commonName = optional
emailAddress = optional
[ext]
{ext}
[req]
distinguished_name = dn
[dn]
"""


def build_steps(keys, certs, crls, params):
    steps = []
    for k in keys:
        steps += keygen_steps(k["name"], k["spec"], k["kind"])
    for p in params:
        steps.append({"run": ["ecparam", "-name", "prime256v1", "-out", f"{p['name']}.pem"]})
    # private keys for every certificate (from the file, or generated, not exported)
    certkey = {}
    for c in certs:
        if c["key"]:
            certkey[c["name"]] = f"{c['key']}.p8"
        else:
            steps += keygen_steps(c["name"] + "k", c["keyspec"], "PRIVATE KEY")
            certkey[c["name"]] = f"{c['name']}k.p8"
    # issuers not present in the file get a synthesized CA (key + self-signed cert, not exported)
    by_subj = {c["subj"]: c for c in certs}
    synth = {}
    issuers = {c["issuer"] for c in certs if c["issuer"] != c["subj"]} | {r["issuer"] for r in crls}
    for dn in issuers:
        if dn not in by_subj:
            n = f"ca{len(synth)}"
            steps += keygen_steps(n + "k", {"alg": "RSA", "bits": 2048, "primes": 2}, "PRIVATE KEY")
            synth[dn] = n
            steps += sign_steps(n, dn, dn, "01", "20000101000000Z", "29991231235959Z", "sha256",
                                ["basicConstraints=critical,CA:TRUE", "keyUsage=keyCertSign,cRLSign"],
                                f"{n}k.p8", None, None)
    # certificates in dependency order (issuer first)
    done = set()

    def emit(c):
        if c["name"] in done:
            return
        if c["issuer"] != c["subj"] and c["issuer"] in by_subj:
            emit(by_subj[c["issuer"]])
        if c["issuer"] == c["subj"]:
            cakey, cacert = certkey[c["name"]], None
        elif c["issuer"] in by_subj:
            ic = by_subj[c["issuer"]]
            cakey, cacert = certkey[ic["name"]], f"{ic['name']}.pem"
        else:
            n = synth[c["issuer"]]
            cakey, cacert = f"{n}k.p8", f"{n}.pem"
        steps.extend(sign_steps(c["name"], c["subj"], c["issuer"], c["serial"], c["nb"], c["na"],
                                c["md"], c["ext"], certkey[c["name"]], cakey, cacert))
        done.add(c["name"])
    for c in certs:
        emit(c)
    for r in crls:
        if r["issuer"] in by_subj:
            ic = by_subj[r["issuer"]]
            cakey, cacert = certkey[ic["name"]], f"{ic['name']}.pem"
        else:
            n = synth[r["issuer"]]
            cakey, cacert = f"{n}k.p8", f"{n}.pem"
        rid = r["name"]
        index = "".join(f"R\t491231235959Z\t{index_time(gentime(d))}\t{s}\tunknown\t/CN=revoked\n"
                        for s, d in r["revoked"])
        conf = CA_CONF.format(id=rid, md=r["md"], ext="",
                              crlnum=f"crlnumber = ./{rid}.crlnum" if r["crlnum"] is not None else "")
        steps += [{"write": f"{rid}.index", "content": index},
                  {"write": f"{rid}.cnf", "content": conf}]
        if r["crlnum"] is not None:
            steps.append({"write": f"{rid}.crlnum", "content": f"{r['crlnum']:02X}\n"})
        steps.append({"run": ["ca", "-batch", "-config", f"{rid}.cnf", "-gencrl", "-keyfile", cakey,
                              "-cert", cacert, "-md", r["md"], "-crl_lastupdate", r["last"],
                              "-crl_nextupdate", r["next"], "-out", f"{rid}.pem"]})
    return steps


def sign_steps(name, subj, issuer, serial, start, end, md, ext, key, cakey, cacert):
    conf = CA_CONF.format(id=name, md=md, ext="\n".join(ext), crlnum="")
    steps = [{"write": f"{name}.cnf", "content": conf},
             {"write": f"{name}.index", "content": ""},
             {"write": f"{name}.serial", "content": serial + "\n"},
             {"run": ["req", "-new", "-config", f"{name}.cnf", "-key", key, "-subj", subj,
                      "-multivalue-rdn", "-out", f"{name}.csr"]}]
    args = ["ca", "-batch", "-config", f"{name}.cnf", "-in", f"{name}.csr", "-out", f"{name}.crt",
            "-startdate", start, "-enddate", end, "-md", md, "-preserveDN", "-notext"]
    if ext:
        args += ["-extensions", "ext"]
    if cacert is None:
        args += ["-selfsign", "-keyfile", cakey or key]
    else:
        args += ["-keyfile", cakey, "-cert", cacert]
    steps.append({"run": args})
    steps.append({"run": ["x509", "-in", f"{name}.crt", "-out", f"{name}.pem"]})
    return steps


PRELUDE = """// Throwaway keys, certificates and CRLs are generated at run time with the openssl CLI
// in a private temporary directory (equivalent to the objects this reproducer was written
// with: same key types/encodings, DNs, serials, dates, extensions, CRL entries); no key
// material is embedded in this file and none is printed.
// Child processes that re-run this file inherit the same objects via REPRO_PEM.
const __pem = (() => {{
  if (process.env.REPRO_PEM) return JSON.parse(process.env.REPRO_PEM);
  const {{ execFileSync }} = require('child_process');
  const __fs = require('fs'), __os = require('os'), __path = require('path');
  const dir = __fs.mkdtempSync(__path.join(__os.tmpdir(), 'repro-pem-'));
  try {{
    for (const s of {steps}) {{
      if (s.write !== undefined) __fs.writeFileSync(__path.join(dir, s.write), s.content);
      else execFileSync('openssl', s.run, {{ cwd: dir, stdio: ['ignore', 'ignore', 'pipe'] }});
    }}
    const out = {{}};
    for (const n of {names}) out[n] = __fs.readFileSync(__path.join(dir, n + '.pem'), 'utf8');
    process.env.REPRO_PEM = JSON.stringify(out);
    return out;
  }} finally {{
    __fs.rmSync(dir, {{ recursive: true, force: true }});
  }}
}})();
"""


def literal_span(js, start, end):
    """Expand a PEM match to the full string expression that contains it."""
    i = start
    while i > 0 and js[i - 1] not in "`'\"":
        i -= 1
    q = js[i - 1]
    if q == "`":
        return start, end, "template"
    j = end
    while j < len(js) and js[j] != q:
        j += 1
    return i - 1, j + 1, "string"


def rewrite(js):
    objs, keys, certs, crls, params = plan(js)
    if not objs:
        return None
    steps = build_steps(keys, certs, crls, params)
    names = [o["name"] for o in objs]
    spans = []
    for o in objs:
        s, e, how = literal_span(js, o["start"], o["end"])
        if how == "template":
            spans.append((o["start"], o["end"], "${__pem." + o["name"] + "}"))
        else:
            spans.append((s, e, "__pem." + o["name"]))
    # merge overlapping string spans (several PEM objects in one string literal)
    merged = []
    for s, e, rep in sorted(spans):
        if merged and s < merged[-1][1]:
            ps, pe, prep = merged[-1]
            merged[-1] = (ps, max(pe, e), f"({prep} + {rep})" if not prep.startswith("(") else prep[:-1] + f" + {rep})")
        else:
            merged.append((s, e, rep))
    out = js
    for s, e, rep in reversed(merged):
        out = out[:s] + rep + out[e:]
    prelude = PRELUDE.format(steps=json.dumps(steps), names=json.dumps(names))
    m = re.match(r"((?:#!.*\n)?(?:\s*(?://[^\n]*|/\*.*?\*/)\s*)*(?:['\"]use strict['\"];?\s*\n)?)", out, re.S)
    head = m.group(1) if m else ""
    return head + prelude + out[len(head):]


if __name__ == "__main__":
    src, dst = sys.argv[1], sys.argv[2]
    new = rewrite(open(src).read())
    if new is None:
        sys.exit("no PEM objects")
    assert "PRIVATE KEY-----" not in new.replace("'PRIVATE KEY'", ""), "literal key left"
    open(dst, "w").write(new)
