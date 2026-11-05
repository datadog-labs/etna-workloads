#!/usr/bin/env python3
"""(Re)create the given (comma-separated) pristine worker trees at the release: export, private index, configure, build."""
import sys, os, shutil
sys.path.insert(0, os.path.dirname(__file__))
import pgrun, tree
from concurrent.futures import ThreadPoolExecutor
IDX = [int(x) for x in sys.argv[1].split(',')]; REL = 'REL_18_6'; N = len(IDX)
def mk(i):
    t = f'{pgrun.WORK}/w/w{i}'; L = f'{pgrun.WORK}/logs/w{i}.build.log'
    shutil.rmtree(t, ignore_errors=True)
    if os.path.exists(L): os.unlink(L)
    tree.init_tree(REL, t)
    return i, pgrun.configure(t, L), pgrun.build(t, L, 4), tree.is_pristine(t)
os.makedirs(f'{pgrun.WORK}/logs', exist_ok=True)
with ThreadPoolExecutor(N) as ex:
    for r in ex.map(mk, IDX): print(r, flush=True)
