#!/usr/bin/env python3
"""Run every needed test unit twice on a built tree; store per-run statuses.

Output JSON: {"runs": {case: [status_run1, status_run2]}, "logs": [...]}
A case is an oracle candidate only if it passes in both runs.
"""
import argparse, json, os, sys
import nodetest


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--tree", required=True)
    ap.add_argument("--node", help="binary (default <tree>/out/Release/node)")
    ap.add_argument("--units", required=True, help="JSON {js: [...], cc: [...]}")
    ap.add_argument("--out", required=True)
    ap.add_argument("--runs", type=int, default=2)
    ap.add_argument("-j", type=int, default=8)
    ap.add_argument("--scratch", required=True)
    ap.add_argument("--logdir", required=True)
    a = ap.parse_args()
    import slot
    slot.require_pristine(a.tree)
    # the slot's binary must match its (pristine) sources: an earlier injection may still be
    # compiled in after its source was reverted
    if os.path.isdir(os.path.join(a.tree, "out")) and not slot.build(a.tree, cctest=bool(json.load(open(a.units)).get("cc"))):
        raise SystemExit("build failed")
    node = a.node or os.path.join(a.tree, "out/Release/node")
    u = json.load(open(a.units))
    runs = {}
    os.makedirs(a.logdir, exist_ok=True)
    for r in range(a.runs):
        res, out = nodetest.run_js(a.tree, node, u["js"], jobs=a.j, scratch=a.scratch)
        open(os.path.join(a.logdir, f"js-run{r + 1}.tap"), "w").write(out)
        cres, cout = nodetest.run_cctest(a.tree, u.get("cc", []))
        open(os.path.join(a.logdir, f"cc-run{r + 1}.log"), "w").write(cout)
        for k, v in {**res, **cres}.items():
            runs.setdefault(k, []).append(v)
        from collections import Counter
        print(f"run {r + 1}:", Counter(list(res.values()) + list(cres.values())), file=sys.stderr)
    json.dump({"runs": runs}, open(a.out, "w"), indent=0, sort_keys=True)


if __name__ == "__main__":
    main()
