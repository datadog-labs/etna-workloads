# Rationale

Reverted the memoized matchall detection in the regex compiler to the pre-fix recursive version.

## Hunks

1. `src/backend/regex/regc_nfa.c`, `checkmatchall()` — traces to the first hunk of fix_impl.patch.
   Restores the version with no `nstates > DUPINF*2` cap and no up-front all-arc scan.
   It uses a single `hasmatch[]` array, and the pseudocolor arc checks are done both ways.

2. `src/backend/regex/regc_nfa.c`, `checkmatchall_recurse()` — traces to the same patch hunks.
   Restores the version with no per-state memoization (`haspaths[]`) and no cancel check.
   It re-explores every path from each state, so time is exponential in the number of
   parallel paths, e.g. for chains of `(x|y)` alternations or `{n,m}` quantifiers.
   Exponential time is the performance bug the fix removed.

3. `src/backend/regex/regc_nfa.c`, `check_out_colors_match()` and `check_in_colors_match()` —
   traces to the same patch hunks.
   Restores the O(N^2) brute-force matching in place of the linear tmp-marking algorithm.

4. `src/backend/regex/regcomp.c` — prototype of `checkmatchall_recurse` changed back to
   `(nfa, s, bool foundloop, int depth, bool *hasmatch)`. This traces to the regcomp.c hunk.

## Failing oracle cases
`src/test/regress||regex` FAILS. The oracle reports it as `['missing']`, meaning the test did not
complete or produce a result. That is consistent with the exponential-time regex compile.
The regex test passes with no change.
