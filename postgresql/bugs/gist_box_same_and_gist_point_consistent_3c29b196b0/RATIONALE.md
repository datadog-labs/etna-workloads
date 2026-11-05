# Rationale

All changes are in src/backend/access/gist/gistproc.c (fix.patch's only implementation file).

1. `gist_box_same()` — traces to the hunk that replaced the box_same() call with exact comparisons. Reverted to calling `box_same` (fuzzy), so GiST equality treats nearly-equal boxes as the same, breaking index consistency.
2. `gist_point_consistent()`, `BoxStrategyNumberGroup` case — traces to the hunk that added the non-fuzzy overlap test. Reverted to calling `gist_box_consistent` with RTOverlapStrategyNumber (fuzzy box_overlap), so point <@ box can visit/return results using fuzzy comparisons, unlike exact on_pb.

The RTSameStrategyNumber hunk in gist_point_consistent_internal was already equivalent in today's code and was left unchanged.

Failing oracle case: src/test/regress||point
