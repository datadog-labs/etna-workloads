"""Headless Claude calls with credential-helper check, retry on API errors, and a spend ledger."""
import json, os, subprocess, time
import pgrun

LEDGER = f'{pgrun.WORK}/state/spend.jsonl'
# Optional API credential-helper check (a command that exits 0 when credentials work), e.g.
# ETNA_CRED_HELPER='my-helper --check'. If unset, no check is made before agent launches.
HELPER = os.environ.get('ETNA_CRED_HELPER', '').split()

def helper_ok():
    if not HELPER:
        return True
    try:
        return subprocess.run(HELPER, capture_output=True, timeout=60).returncode == 0
    except Exception:
        return False

def wait_helper(max_wait=3600):
    t0 = time.time()
    while not helper_ok():
        if time.time() - t0 > max_wait:
            raise RuntimeError('credential helper failing for too long')
        time.sleep(60)

def spent(stage=None):
    if not os.path.exists(LEDGER): return 0.0
    return sum(j['usd'] for j in map(json.loads, open(LEDGER)) if stage is None or j['stage'] == stage)

def record(stage, key, usd, extra=None):
    os.makedirs(os.path.dirname(LEDGER), exist_ok=True)
    with open(LEDGER, 'a') as f:
        f.write(json.dumps(dict(t=time.time(), stage=stage, key=key, usd=usd, **(extra or {}))) + '\n')

def claude(prompt, model, stage, key, cwd, settings=None, max_turns=1, timeout=900, extra_args=(),
           env=None, retries=4):
    """Run claude -p; returns parsed JSON result dict. Raises RetryableError after retries."""
    last = None
    for attempt in range(retries):
        wait_helper()
        args = ['claude', '-p', '--model', model, '--output-format', 'json', '--max-turns', str(max_turns), '--strict-mcp-config']
        if settings: args += ['--settings', settings]
        args += list(extra_args)
        import signal
        p = subprocess.Popen(args, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                             text=True, cwd=cwd, env=env, start_new_session=True)
        try:
            out, err = p.communicate(prompt, timeout=timeout)
        except subprocess.TimeoutExpired:
            try: os.killpg(p.pid, signal.SIGKILL)
            except OSError: pass
            p.communicate()
            record(stage, key, 3.0, dict(error='timeout; cost unknown, $3 charged as an estimate'))
            return dict(subtype='timeout', is_error=True, result='agent timed out', total_cost_usd=None)
        try:
            d = json.loads(out)
        except Exception as e:
            last = f'bad output rc={p.returncode} {err[-300:]}'
            time.sleep(30 * (attempt + 1)); continue
        usd = float(d.get('total_cost_usd') or 0)
        record(stage, key, usd, dict(model=model, turns=d.get('num_turns'), is_error=d.get('is_error'),
                                     subtype=d.get('subtype')))
        if d.get('is_error') and d.get('subtype') not in ('error_max_turns',):
            r = str(d.get('result', ''))
            if any(s in r.lower() for s in ('api error', 'overloaded', 'rate limit', '529', '500', 'timeout', 'credential')):
                last = r[:300]; time.sleep(60 * (attempt + 1)); continue
        return d
    raise RetryableError(last)

class RetryableError(Exception):
    pass
