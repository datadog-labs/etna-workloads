# Rationale

File: src/src/optimizer/topn_window_elimination.cpp

1. `TopNWindowElimination::OptimizeInternal`: removed the early block that skipped projections to the window, recursively optimized `window.children[0]` with a local `ColumnBindingReplacer`, and propagated the replacements to the owning plan and the caller's replacer. Restored the original late `window.children[0] = Optimize(...)` (a separate, top-level replacer) and the `auto &window` declaration after the bindings traversal. This traces to the fix's first three hunks. Bindings changed by nested Top-N rewrites are no longer propagated, which is the test_24710 bug.
2. `CanUseLateMaterialization`: a non-comparison join condition now does `return false` instead of `continue`. I changed this to match the fix's hunk 4 direction, so the code is the pre-fix form. The pre-fix code returned false here, and today's code skips the condition.

I did not revert the `TryPrepareLateMaterialization` rowid-binding hunks. Today's code differs from the fix's parent there, and reverting only the first two hunks was enough to bring back the failure.

## Oracle result
```
FAIL     test/issues/general/test_24710.test
         INTERNAL Error: Failed to bind column reference "#[0.1]" [0.1] (bindings: {#[18.0], #[18.1]})
PASS     test/issues/general/test_24711.test
1 of 2 oracle units fail
```
test_24711 still passes, because the rowid-binding hunks were not reverted.
