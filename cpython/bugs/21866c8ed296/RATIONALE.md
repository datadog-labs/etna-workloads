# Rationale (gh-120367)

Fix hunks: (a) new helper `remove_redundant_nops_and_jumps()`, (b) `optimize_cfg` uses it, (c) `push_cold_blocks_to_end` calls it instead of `remove_redundant_jumps()`.
In v3.15.2 the helper already exists and is used in several places, so only the call sites are reverted (both in Python/flowgraph.c):

1. `push_cold_blocks_to_end`: `remove_redundant_nops_and_jumps(g)` -> `remove_redundant_jumps(g)`.
   Reverses hunk (c): after moving cold blocks, only jumps are cleaned up, not NOPs, and not iterating to a fixpoint.
2. `convert_pseudo_ops` (end): `remove_redundant_nops_and_jumps(g)` -> `remove_redundant_nops(g)`.
   Later code that covers the same case (the bug was effectively fixed twice: the same helper cleans NOPs/jumps created by
   reordering after pseudo-op conversion). Without this, the later pass hides the bug from step 1.

Result: the oracle test `test_compile_redundant_jumps_and_nops_after_moving_cold_blocks` fails (the interpreter crashes on
an assert for redundant nops/jumps; the run aborts, so many later cases in test_compile.py are reported failing, and
`test_compile_redundant_jump_after_convert_pseudo_ops` also fails due to change 2).
