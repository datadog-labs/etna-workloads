#!/usr/bin/env python3
"""Verify a reproducer: deterministic on the clean build (2 runs), differs on the injected build
(output or exit status, 2 runs agreeing). Rejects reproducers that print version/build identifiers.
usage: repro_check.py CLEAN_BINDIR INJECTED_BINDIR REPRO_FILE [EXPECTED_OUT_TO_WRITE]"""
import subprocess, sys, os, re, tempfile, json
HERE = os.path.dirname(os.path.abspath(__file__))
FORBID = re.compile(r'version\s*\(|server_version|pg_config|pg_control_system|--version|\bPG_VERSION\b|pg_backend_pid|now\s*\(|clock_timestamp|random\s*\(|txid_current|pg_current_xact_id|inet_server_port', re.I)

def run(bindir, repro):
    with tempfile.NamedTemporaryFile(dir=os.environ.get('TMPDIR'), delete=False) as f:
        out = f.name
    rc = subprocess.run([f'{HERE}/repro_run.sh', bindir, repro, out], capture_output=True).returncode
    text = open(out, errors='replace').read(); os.unlink(out)
    return rc, text

def check(clean, inj, repro):
    src = open(repro, errors='replace').read()
    if FORBID.search(src):
        return dict(ok=False, why='reproducer uses a version/time/pid/random identifier: ' + FORBID.search(src).group(0))
    c1, c2 = run(clean, repro), run(clean, repro)
    if c1 != c2:
        return dict(ok=False, why='clean output not deterministic')
    if c1[0] in (97, 98):
        return dict(ok=False, why='clean cluster failed to start')
    i1, i2 = run(inj, repro), run(inj, repro)
    if i1 == c1 or i2 == c1:
        return dict(ok=False, why='injected output equals clean output', clean_rc=c1[0])
    return dict(ok=True, clean_rc=c1[0], injected_rc=i1[0], injected_stable=(i1 == i2),
                clean_out=c1[1], injected_out=i1[1])

if __name__ == '__main__':
    r = check(*sys.argv[1:4])
    if r['ok'] and len(sys.argv) > 4:
        open(sys.argv[4], 'w').write(r['clean_out'])
    print(json.dumps({k: v for k, v in r.items() if not k.endswith('_out')}))
    sys.exit(0 if r['ok'] else 1)
