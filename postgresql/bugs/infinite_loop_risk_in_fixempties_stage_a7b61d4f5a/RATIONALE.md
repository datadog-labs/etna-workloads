# Rationale

Bug: fixempties() used an iterate-until-no-progress loop (unempty()) that can re-add EMPTY arcs and never terminate. The fix replaced it with a terminating algorithm.

## Hunks
- `src/backend/regex/regc_nfa.c`, `fixempties()` and `emptyreachable()`: traces to the fix.patch hunk that rewrites fixempties() and replaces unempty() with emptyreachable()/replaceempty(). The current multi-phase algorithm (the single-state alias passes, inarcsorig/mergeins and emptyreachable) is replaced by the original do/while loop calling `unempty()`, which is restored in the same place. Successive passes can re-add EMPTY arcs, so termination is no longer guaranteed.
- `src/backend/regex/regcomp.c`, prototypes: traces to the fix.patch prototype hunk. The `emptyreachable` prototype is replaced by the `unempty` prototype.

Helpers such as `hasnonemptyout` are left in place but are now unused.

## Failing oracle cases
- src/test/regress||regex
