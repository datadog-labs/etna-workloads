"""Retry failed adapted attempts with the largest model (newest first, under a cap).
Retry-eligible: agent ran, gate failed, not a setup problem.  The first attempt is kept
in the result under 'previous'."""
import argparse, json, queue, threading, time, traceback
from common import *
import adapted as A, llm, sandbox
from slots import Slot


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--cap", type=float, required=True)
    ap.add_argument("--par", type=int, default=3)
    ap.add_argument("--first-slot", type=int, default=5)
    ap.add_argument("--model", default="opus")
    ap.add_argument("--limit", type=int, default=0)
    a = ap.parse_args()
    # Safety net: re-run attempts that ended in a retryable (API/credential) error with the
    # default model first; they are not results.
    import subprocess, sys
    pending = [json.loads(f.read_text())["sha"] for f in A.OUT.glob("*.json")
               if json.loads(f.read_text()).get("retryable")]
    if pending:
        print(len(pending), "retryable records: re-running with the default model", flush=True)
        subprocess.run([sys.executable, "adapted.py", "--cap", "170", "--par", str(a.par),
                        "--first-slot", str(a.first_slot), "--only", ",".join(pending)])
    why = dict((c["sha"], w) for c, w in A.eligible())
    cands = {c["sha"]: c for c in load("candidates.json")}
    todo = []
    for f in A.OUT.glob("*.json"):
        r = json.loads(f.read_text())
        if r.get("retryable"):
            continue    # API/credential errors are not results: re-run with the default model below
        if r.get("gate") or r.get("previous") or r.get("model") == a.model:
            continue
        if r.get("skip") in ("no-oracle", "prepare-failed") or r["sha"] not in why:
            continue
        todo.append((cands[r["sha"]], r))
    todo.sort(key=lambda t: -t[0]["ts"])
    if a.limit:
        todo = todo[:a.limit]
    print(len(todo), "retries; spent", round(llm.spent("adapted-retry"), 2), flush=True)
    if not todo or not sandbox.sbx_check()[0]["ok"]:
        return
    q = queue.Queue()
    for t in todo:
        q.put(t)

    def worker(n):
        slot = Slot(n)
        slot.prepare()
        while llm.spent("adapted-retry") < a.cap:
            try:
                c, prev = q.get_nowait()
            except queue.Empty:
                return
            disk_wait()
            t = time.time()
            try:
                res = A.process(slot, c, a.model, why[c["sha"]], 8.0, stage="adapted-retry")
            except Exception:
                res = dict(sha=c["sha"], error=traceback.format_exc(), retryable=True)
            disk_taint(res)
            if res.get("retryable"):
                print(c["sha"][:10], "retryable error; keeping first attempt", flush=True)
                A.cleanup(c); slot.reset()
                continue
            res["previous"] = prev
            res["secs"] = round(time.time() - t)
            (A.OUT / f"{c['sha']}.json").write_text(json.dumps(res, indent=1))
            print(c["sha"][:10], "retry gate=", res.get("gate"), res.get("failing"), res.get("skip", ""),
                  "spent", round(llm.spent("adapted-retry"), 2), flush=True)
            A.cleanup(c)
            slot.reset()

    ths = [threading.Thread(target=worker, args=(a.first_slot + i,)) for i in range(a.par)]
    for t in ths:
        t.start()
    for t in ths:
        t.join()


if __name__ == "__main__":
    main()
