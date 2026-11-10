#!/usr/bin/env python3
"""Run every needed test unit on the base build, sharded over private trees.

Usage: baserun.py units_all.json RUN_NAME [shards]
Writes WORK/baseruns/RUN_NAME/shard-K.jsonl and results.json {title: status}.
"""
import json, os, sys, time
from concurrent.futures import ThreadPoolExecutor

sys.path.insert(0, os.path.dirname(__file__))
import tstree


def main(units_json, name, shards=12):
    shards = int(shards)
    u = json.load(open(units_json))
    allu = sorted({(x["runner"], x["grep"]) for k in u for x in u[k]})
    out = os.path.join(tstree.WORK, "baseruns", name)
    os.makedirs(out, exist_ok=True)
    parts = [allu[i::shards] for i in range(shards)]

    def run(i):
        tree = os.path.join(tstree.WORK, "trees", f"base-{name}-{i}")
        tstree.rm_tree(tree)
        tstree.mk_tree(tree)
        t = time.time()
        st = tstree.run_units(tree, parts[i], f"{out}/shard-{i}.jsonl", f"{out}/shard-{i}.log", timeout=5400)
        tstree.rm_tree(tree)
        return i, st, time.time() - t

    with ThreadPoolExecutor(shards) as ex:
        for i, st, dt in ex.map(run, range(shards)):
            print(f"shard {i} {dt:.0f}s {st}", flush=True)
    res, inc = {}, []
    for i in range(shards):
        r, m = tstree.parse(f"{out}/shard-{i}.jsonl")
        res.update(r)
        inc += [(i, g) for g in m["incomplete"]]
    json.dump({"results": res, "incomplete": inc}, open(f"{out}/results.json", "w"))
    print("cases", len(res), "incomplete", inc)


if __name__ == "__main__":
    main(*sys.argv[1:])
