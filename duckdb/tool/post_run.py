#!/usr/bin/env python3
"""After the chain's deadline: finish what is left without starting new candidates.
  * anchors for adapted gate passes that have none (anchor slot, newest first; compute only)
  * re-run adapted attempts whose verdict is 'infra' (API/credential failures)
  * reproducer agents for gate passes without a reproducer, on several free slots, within --cap-repro
usage: post_run.py --cap-repro USD [--repro-slots r1,s1,s2] [--adapted-slot a1]
"""
import argparse, json, os, queue, threading, time, traceback
import common, llm, anchor, adapt, repro_agent

ap = argparse.ArgumentParser()
ap.add_argument("--cap-repro", type=float, required=True)
ap.add_argument("--repro-slots", default="r1,s1,s2")
ap.add_argument("--adapted-slot", default="a1")
a = ap.parse_args()
LOG = open(os.path.join(common.WORK, "logs", "post_run.log"), "a", buffering=1)
def log(*x): LOG.write(time.strftime("%Y-%m-%d %H:%M:%S ") + " ".join(map(str, x)) + "\n")

ORDER = [c["sha"] for c in common.candidates()]
CANDS = {c["sha"]: c for c in common.candidates()}
base = common.base_oracle(); um = common.units_map()
def res(tier, s):
    p = f"{common.RESULTS}/{tier}/{s}/result.json"
    return json.load(open(p)) if os.path.exists(p) else None

def anchors():
    src = os.path.join(common.WORK, "slots", "anchor", "src")
    todo = [s for s in ORDER if (res("adapted", s) or {}).get("verdict") == "pass"
            and not os.path.exists(f"{common.RESULTS}/anchor/{s}/result.json")]
    log("anchors to do", len(todo))
    for s in todo:
        out = f"{common.RESULTS}/anchor/{s}/result.json"
        try:
            r = anchor.anchor(src, CANDS[s], res("adapted", s)["failing"], os.path.dirname(out))
        except Exception:
            r = {"sha": s, "status": "infra", "error": traceback.format_exc()[-1500:]}
        common.write_json(out, r); log("anchor", s[:10], r.get("status"))

def adapted_infra():
    slot = os.path.join(common.WORK, "slots", a.adapted_slot)
    todo = [s for s in ORDER if (res("adapted", s) or {}).get("verdict") == "infra"]
    log("adapted infra retries", len(todo))
    for s in todo:
        while not llm.credential_ok():
            time.sleep(120)
        outdir = f"{common.RESULTS}/adapted/{s}"
        os.rename(outdir, outdir + ".infra-" + time.strftime("%H%M")); os.makedirs(outdir)
        oracle = [u for u in um[s]["units"] if base.get(u) == "pass"]
        r = adapt.adapt(slot, CANDS[s], oracle, "does not apply", "sonnet", 5.0, 10800, outdir)
        common.write_json(os.path.join(outdir, "result.json"), r); log("adapted retry", s[:10], r.get("verdict"))

def regate_pycache_only():
    """Re-verify adapted attempts rejected only because of __pycache__ by-products (harness false positive)."""
    import gate, repro
    slot = os.path.join(common.WORK, "slots", a.adapted_slot); src = os.path.join(slot, "src")
    for s in ORDER:
        r = res("adapted", s)
        if not r or r.get("verdict") != "rejected-outside-scope":
            continue
        if any("__pycache__/" not in n and not n.endswith(".pyc") for n in r.get("outside_scope", [])):
            continue
        outdir = f"{common.RESULTS}/adapted/{s}"
        inj = open(os.path.join(outdir, "injection.patch"), "rb").read()
        common.sync_tree(src)
        if gate.apply_patch(src, inj) != "clean":
            r["verdict"] = "apply-fail"
        else:
            def mk(tree, rr):
                rep, att = repro.mechanical(common.BASE, tree, rr["failing"], {u: rr["runs"][0][u][1] for u in rr["failing"]})
                if rep:
                    open(os.path.join(outdir, "repro.sql"), "w").write(rep["sql"])
                return {"repro": rep, "repro_attempts": att}
            r.update(gate.gate(src, inj, r["oracle"], outdir, jobs=6, on_injected=mk))
        r["regated"] = "outside-scope rejection was __pycache__ only (harness false positive); re-gated by harness"
        common.sync_tree(src)
        common.write_json(os.path.join(outdir, "result.json"), r); log("regate", s[:10], r.get("verdict"))


rq = queue.Queue()
for s in ORDER:
    for tier in ("verbatim", "adapted"):
        r = res(tier, s)
        if r and r.get("verdict") == "pass" and r.get("reverse_ok") and not r.get("repro") and \
                not os.path.exists(f"{common.RESULTS}/{tier}/{s}/repro-agent-result.json"):
            rq.put((tier, s))
log("repro jobs", rq.qsize())

def repro_worker(name):
    slot = os.path.join(common.WORK, "slots", name)
    while True:
        try:
            tier, s = rq.get_nowait()
        except queue.Empty:
            return
        if llm.spent("repro") >= a.cap_repro:
            log("repro cap reached"); return
        while not llm.credential_ok():
            time.sleep(120)
        try:
            o, rdir = repro_agent.run(slot, f"{common.RESULTS}/{tier}/{s}/result.json", "sonnet", 2.0, 2700)
            if o.get("verdict") == "infra":
                log("repro", name, tier, s[:10], "infra (will not record)"); continue
            common.write_json(os.path.join(rdir, "repro-agent-result.json"), o)
            log("repro", name, tier, s[:10], o["verdict"], "$%.3f" % o.get("agent", {}).get("cost", 0))
        except Exception:
            log("repro", name, s[:10], "error", traceback.format_exc()[-600:])

regate_pycache_only()  # before the threads: uses the adapted slot
ts = [threading.Thread(target=anchors), threading.Thread(target=adapted_infra)]
ts += [threading.Thread(target=repro_worker, args=(n,)) for n in a.repro_slots.split(",")]
for t in ts: t.start()
for t in ts: t.join()
anchors()  # one more pass for gate passes produced by the infra retries (single thread: one anchor slot)
log("post_run end; spend", {k: round(llm.spent(k), 2) for k in ("triage", "adapted", "repro")})
