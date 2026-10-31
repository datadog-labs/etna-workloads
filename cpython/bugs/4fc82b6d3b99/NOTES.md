Reproducer compiles the gh-120225 source (async function with match/guard/async comprehension) via `compile()`.
Clean: prints `compiled`. Buggy: aborts (SIGABRT) with `flowgraph.c:3551: push_cold_blocks_to_end: Assertion `prev_instr' failed`.
