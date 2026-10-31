# gh-120225 reintroduced

Change: `Python/flowgraph.c`, `push_cold_blocks_to_end()`, in the loop that adds an explicit jump after a cold block that falls through to a warm block.

Reverses the single fix hunk:
- Restores `prev_instr = basicblock_last_instr(b)` plus `assert(prev_instr)`, and uses `prev_instr->i_loc` as the jump's location instead of `NO_LOCATION`. When `b` is an empty block at the end of an exception handler, `prev_instr` is NULL, so this asserts (debug build) or dereferences NULL (release build).
- Removes `explicit_jump->b_predecessors = 1;`, which the fix added. It is now missing again, as before the fix.

Oracle: the oracle's `test_regression_gh_120225` compiles the match/async-comprehension snippet. That compile crashes, which aborts the test_compile run. check.sh reports 118 of 187 oracle cases failing and marks the run incomplete because of the crash.
