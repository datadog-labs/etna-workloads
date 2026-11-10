#!/usr/bin/env python3
"""Quiet recheck: re-gate bugs on an otherwise idle machine, one at a time, tests serial.

Targets: every gated bug whose failing cases failed only by timeout (could be load), plus
a random sample of the others (measures the false-positive rate of running under load).
confirmed = the stored injection's failing cases fail in two serial runs again.
"""
import argparse, json, os, random, subprocess, sys
import gate, nodetest, slot as S


def recheck(b, slotdir):
    S.require_pristine(slotdir)
    inj = b["injection"].encode()
    files = S.patch_files(b["injection"])
    assert S.apply(slotdir, inj, fuzz=False), "injection does not apply"
    try:
        cc = [c for c in b["failing"] if c.startswith("cctest:")]
        if not S.build(slotdir, cctest=bool(cc)):
            return {"confirmed": False, "why": "build-fail"}
        js = sorted({gate.unit_of(c) for c in b["failing"] if not c.startswith("cctest:")})
        runs = []
        for _ in range(2):
            r, _ = nodetest.run_js(slotdir, os.path.join(slotdir, "out/Release/node"), js, jobs=1,
                                   scratch=os.path.expanduser("~/node-etna-work/tmp"))
            rc, _ = nodetest.run_cctest(slotdir, cc)
            runs.append({**r, **rc})
        still = [c for c in b["failing"] if all(r.get(c) in ("fail", "crash", "timeout") for r in runs)]
        return {"confirmed": bool(still), "still_failing": still, "runs": runs}
    finally:
        subprocess.run(["patch", "-p1", "-R", "-s", "--no-backup-if-mismatch"], cwd=slotdir, input=inj)
        if S.matches_pristine(slotdir, files):
            S.restore(slotdir, files)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--bugs", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--slot", required=True)
    ap.add_argument("--sample", type=int, default=30)
    ap.add_argument("--extra", help="file with additional shas to recheck (kind=extra)")
    a = ap.parse_args()
    bugs = [json.loads(l) for l in open(a.bugs)]
    done = set()
    if os.path.exists(a.out):
        done = {json.loads(l)["sha"] for l in open(a.out)}

    def timeout_only(b):
        runs = b.get("inj_runs") or b.get("gate", {}).get("inj_runs") or []
        return all(all(r.get(c) == "timeout" for r in runs) for c in b["failing"])
    tonly = [b for b in bugs if timeout_only(b)]
    rest = [b for b in bugs if not timeout_only(b)]
    random.seed(20261103)
    sample = random.sample(rest, min(a.sample, len(rest)))
    extra = []
    if a.extra:
        want = set(open(a.extra).read().split())
        extra = [b for b in bugs if b["sha"] in want]
    for kind, group in (("timeout-only", tonly), ("sample", sample), ("extra", extra)):
        for b in group:
            if b["sha"] in done:
                continue
            r = recheck(b, a.slot)
            r.update(sha=b["sha"], kind=kind, tier=b["tier"])
            with open(a.out, "a") as f:
                f.write(json.dumps(r) + "\n")
            print(f"{b['sha'][:10]} {kind:12} confirmed={r['confirmed']}", flush=True)


if __name__ == "__main__":
    main()
