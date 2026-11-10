# Rationale

**Bug:** `AsyncWrap::EmitDestroy` did not release the async context frame (`context_frame_`), so destroyed/reused resources (e.g. pooled HTTPParser) kept AsyncLocalStorage stores alive and prevented GC.

**Hunk (src/async_wrap.cc, EmitDestroy):** corresponds to the fix's EmitDestroy hunk. The fix nested the resource_symbol self-reference inside `if (!from_gc)` and added a context-frame reset there (today spelled `set_context_frame({})`). I restored the old form `if (!persistent().IsEmpty() && !from_gc) {...}` with no frame reset, so the frame stays referenced after destroy.

The fix's DEBUG-only MakeCallback warning hunk (and its include) is not reproduced: it was a diagnostic added with the fix, not part of the defect, and the current tree doesn't contain it in that form.

**Failing test:** `parallel/test-async-local-storage-http-parser-leak` -> `not ok`, `AssertionError [ERR_ASSERTION]: The expression evaluated to a falsy value` (storeGCed is false). Stable across 2 runs.
