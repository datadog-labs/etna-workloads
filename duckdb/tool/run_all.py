#!/usr/bin/env python3
"""Unattended full run: verbatim, adapted (newest first), anchor, reproducer agents — resumable.

Workers (threads), each owning fixed-path build slots:
  verbatim  x V  slots v1..vV      clean/fuzzy candidates with an oracle; triaged bugs first, newest first
  adapted   x A  slots a1..aA      triaged-bug candidates whose reversal conflicts (or did not fail / build);
                                   fix-added oracle first, newest first; one retry with the largest model
                                   for failed attempts once the main queue is exhausted
  anchor    x 1  slot  anchor      adapted gate passes, newest first (incremental walk back in time)
  repro     x 1  slot  r1          gate passes without a mechanical reproducer
Stops on: STOP file, --deadline (epoch secs), or every queue exhausted. Spend caps per stage (USD).
Every stage is resumable: finished results are skipped on restart.
"""
import argparse, json, os, queue, shutil, subprocess, sys, threading, time, traceback
import common, gate, llm, verbatim_lib, adapt, anchor
import repro_agent as repro_agent_lib

ap = argparse.ArgumentParser()
ap.add_argument("--verbatim-slots", type=int, default=3); ap.add_argument("--adapted-slots", type=int, default=2)
ap.add_argument("--cap-adapted", type=float, required=True); ap.add_argument("--cap-repro", type=float, required=True)
ap.add_argument("--deadline", type=float, required=True)
ap.add_argument("--model", default="sonnet"); ap.add_argument("--retry-model", default="opus")
ap.add_argument("--budget", type=float, default=5.0); ap.add_argument("--retry-budget", type=float, default=8.0)
a = ap.parse_args()

LOG = open(os.path.join(common.WORK, "logs", "run_all.log"), "a", buffering=1)
lock = threading.Lock()


def log(*x):
    with lock:
        LOG.write(time.strftime("%Y-%m-%d %H:%M:%S ") + " ".join(str(i) for i in x) + "\n")


def stopping():
    return os.path.exists(os.path.join(common.WORK, "STOP")) or time.time() > a.deadline


def ensure_slot(name):
    """A fixed-path, configured, built release tree at slots/<name>/src (built from ccache on first use)."""
    src = os.path.join(common.WORK, "slots", name, "src")
    if not os.path.exists(os.path.join(src, "build/relassert/test/unittest")):
        os.makedirs(src, exist_ok=True)
        common.sync_tree(src)
        b = gate.build(src, os.path.join(common.WORK, "logs", f"slot-{name}-build.log"))
        if b["status"] != "exit" or b["rc"] != 0:
            raise RuntimeError(f"slot {name} failed to build: {b}")
    return src


CANDS = {c["sha"]: c for c in common.candidates()}
ORDER = [c["sha"] for c in common.candidates()]  # newest first
TRI = {s: json.load(open(f"{common.RESULTS}/triage/{s}.json")) for s in ORDER if os.path.exists(f"{common.RESULTS}/triage/{s}.json")}
PROBE = {r["sha"]: r["apply"] for r in common.load_jsonl(os.path.join(common.WORK, "probe.jsonl"))}
BASE = common.base_oracle()
UM = common.units_map()


def oracle_of(s):
    return [u for u in UM[s]["units"] if BASE.get(u) == "pass"]


def added_oracle(s):
    return [u for u in UM[s]["added"] if BASE.get(u) == "pass"]


def is_bug(s):
    return TRI.get(s, {}).get("label") == "bug"


def vres(s):
    p = f"{common.RESULTS}/verbatim/{s}/result.json"
    return json.load(open(p)) if os.path.exists(p) else None


def ares(s):
    p = f"{common.RESULTS}/adapted/{s}/result.json"
    return json.load(open(p)) if os.path.exists(p) else None


# ---------------- queues ----------------
vq = [s for s in ORDER if PROBE[s] in ("clean", "fuzzy") and oracle_of(s)]
vq = [s for s in vq if is_bug(s)] + [s for s in vq if not is_bug(s)]
vlock = threading.Lock()


def next_verbatim():
    with vlock:
        while vq:
            s = vq.pop(0)
            r = vres(s)
            if r is None or r.get("verdict") == "infra":
                return s
    return None


claimed = set()
alock = threading.Lock()


def adapted_eligible(s):
    if not is_bug(s) or not oracle_of(s):
        return False
    if PROBE[s] == "conflict":
        return True
    r = vres(s)
    return r is not None and r.get("verdict") in ("no-fail", "build-fail", "apply-fail")


def next_adapted():
    """Fix-added-oracle candidates first, newest first; then the rest; then retries with the large model."""
    with alock:
        for phase in ("added", "rest"):
            for s in ORDER:
                if s in claimed or not adapted_eligible(s):
                    continue
                if (phase == "added") != bool(added_oracle(s)):
                    continue
                r = ares(s)
                if r is None or r.get("verdict") == "infra":
                    claimed.add(s); return s, "first"
        # main queue exhausted (only if verbatim is done too, so late verbatim no-fails are not missed)
        if vq:
            return None, "wait"
        for s in ORDER:
            r = ares(s)
            if s in claimed or r is None or not added_oracle(s):
                continue
            if r.get("verdict") in ("no-fail", "no-change", "build-fail", "no-rationale", "agent-timeout") and not r.get("retry_of"):
                claimed.add(s); return s, "retry"
    return None, "done"


# ---------------- workers ----------------
def verbatim_worker(name):
    src = ensure_slot(name)
    fast = []
    while not stopping():
        s = next_verbatim()
        if s is None:
            log(name, "verbatim queue empty"); return
        r = verbatim_lib.run_one(src, CANDS[s], BASE, UM)
        log(name, "verbatim", s[:10], r.get("verdict"), len(r.get("failing", [])), r.get("wall_secs"))
        if r.get("verdict") == "pass" and not r.get("repro"):
            rq.put(("verbatim", s))
        if r.get("verdict") in ("build-fail", "infra") and (r.get("build") or {}).get("secs", 999) < 60:
            fast.append((r["verdict"], tuple(r.get("build_errors", [])[:1])))
            if len(fast) >= 5 and len(set(fast[-5:])) == 1:
                log(name, "STOPPING worker: 5 identical fast failures", fast[-1]); return
        else:
            fast = []


def adapted_worker(name):
    slot = os.path.dirname(ensure_slot(name))
    while not stopping():
        if llm.spent("adapted") >= a.cap_adapted:
            log(name, "adapted cap reached"); return
        s, kind = next_adapted()
        if kind == "wait":
            time.sleep(300); continue
        if s is None:
            log(name, "adapted queue empty"); return
        while not llm.credential_ok():
            log(name, "credential probe failed; waiting"); time.sleep(120)
            if stopping():
                return
        c = CANDS[s]
        outdir = os.path.join(common.RESULTS, "adapted", s)
        prev = ares(s)
        if kind == "retry":
            shutil.move(outdir, outdir + f".{a.model}")
        os.makedirs(outdir, exist_ok=True)
        why = "does not apply" if PROBE[s] == "conflict" else f"applies but its verbatim gate gave '{vres(s)['verdict']}'"
        model, budget = (a.retry_model, a.retry_budget) if kind == "retry" else (a.model, a.budget)
        try:
            r = adapt.adapt(slot, c, oracle_of(s), why, model, budget, 10800, outdir)  # header changes can need 40+ min builds
        except Exception:
            r = {"sha": s, "verdict": "infra", "error": traceback.format_exc()[-2000:]}
            common.sync_tree(os.path.join(slot, "src"))
        if kind == "retry":
            r["retry_of"] = prev.get("model")
        common.write_json(os.path.join(outdir, "result.json"), r)
        log(name, "adapted", kind, model, s[:10], r.get("verdict"), r.get("failing"), "$%.3f" % r.get("agent", {}).get("cost", 0))
        if r.get("verdict") == "pass":
            anq.put(s)
            if not r.get("repro"):
                rq.put(("adapted", s))
        if r.get("verdict") == "infra":
            with alock:
                claimed.discard(s)
            time.sleep(60)


anq = queue.Queue()
rq = queue.Queue()


def anchor_worker():
    src = os.path.join(common.WORK, "slots", "anchor", "src"); os.makedirs(src, exist_ok=True)
    pending = []
    while True:
        try:
            pending.append(anq.get(timeout=60))
        except queue.Empty:
            pass
        if stopping():
            return
        if all_done.is_set() and not pending and anq.empty():
            return
        if not pending:
            continue
        pending.sort(key=lambda s: ORDER.index(s))  # newest first: incremental walk back in time
        s = pending.pop(0)
        out = os.path.join(common.RESULTS, "anchor", s, "result.json")
        if os.path.exists(out) and json.load(open(out)).get("status") not in ("infra",):
            continue
        cases = ares(s)["failing"]
        try:
            r = anchor.anchor(src, CANDS[s], cases, os.path.dirname(out))
        except Exception:
            r = {"sha": s, "status": "infra", "error": traceback.format_exc()[-2000:]}
        common.write_json(out, r)
        log("anchor", s[:10], r.get("status"), r.get("anchor_failing"))


def repro_worker():
    name = "r1"
    slot = os.path.dirname(ensure_slot(name))
    while True:
        try:
            tier, s = rq.get(timeout=60)
        except queue.Empty:
            if stopping() or all_done.is_set():
                return
            continue
        if stopping():
            return
        if llm.spent("repro") >= a.cap_repro:
            log("repro cap reached"); continue
        rp = os.path.join(common.RESULTS, tier, s, "result.json")
        if os.path.exists(os.path.join(common.RESULTS, tier, s, "repro-agent-result.json")):
            continue
        while not llm.credential_ok():
            time.sleep(120)
        try:
            o, rdir = repro_agent_lib.run(slot, rp, "sonnet", 2.0, 2700)
            common.write_json(os.path.join(rdir, "repro-agent-result.json"), o)
            log("repro", tier, s[:10], o["verdict"], "$%.3f" % o.get("agent", {}).get("cost", 0))
        except Exception:
            log("repro", tier, s[:10], "error", traceback.format_exc()[-800:])


# re-enqueue work left over from an earlier (interrupted) run
for s in ORDER:
    r = ares(s)
    if r and r.get("verdict") == "pass":
        o = os.path.join(common.RESULTS, "anchor", s, "result.json")
        if not os.path.exists(o):
            anq.put(s)
    for tier, rr in (("verbatim", vres(s)), ("adapted", r)):
        if rr and rr.get("verdict") == "pass" and not rr.get("repro") and \
                not os.path.exists(os.path.join(common.RESULTS, tier, s, "repro-agent-result.json")):
            rq.put((tier, s))

all_done = threading.Event()
log("run_all start", vars(a), "verbatim queue", len(vq))
workers = [threading.Thread(target=verbatim_worker, args=(f"s{i+1}",), name=f"s{i+1}") for i in range(a.verbatim_slots)]
workers += [threading.Thread(target=adapted_worker, args=(f"a{i+1}",), name=f"a{i+1}") for i in range(a.adapted_slots)]
for w in workers:
    w.start()
aux = [threading.Thread(target=anchor_worker, name="anchor"), threading.Thread(target=repro_worker, name="repro")]
for w in aux:
    w.start()
for w in workers:
    w.join()
all_done.set()
for w in aux:
    w.join()
log("run_all end; spend", {k: round(llm.spent(k), 2) for k in ("triage", "adapted", "repro")})
