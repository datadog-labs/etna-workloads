Changed hunks (all trace to FIX.diff):
1. doc.cpp set_and: neg().intersect(m, dst.pos()) -> src.pos() (FIX hunk 1; the neg set must be intersected with the new, combined pos).
2. doc.cpp fold_neg count==1 branch: intersect(tbvm(), dst.pos()) -> erase(tbvm(), i) (FIX hunk 3; after narrowing pos, other negs are not re-intersected, leaving ill-formed docs).
3. doc.h union_bvec::intersect(union_bvec): restored the old pairwise-intersection implementation (FIX doc.h hunk).
Not reverted: SASSERT(well_formed) additions and IF_VERBOSE logging (non-behavioral).

Final ./check.sh output:
BUILD OK
FAIL doc (rc=110)
    xxxx \ {xxx0}
    xxx
    (or (and true (not (not true))) (and true (not (not false)))) true
    ASSERTION VIOLATION
    File: <z3-src>/src/muz/rel/doc.cpp
    Line: 169
    well_formed(dst)
    (C)ontinue, (A)bort, (S)top, (T)hrow exception, Invoke (G)DB, Invoke (L)LDB
