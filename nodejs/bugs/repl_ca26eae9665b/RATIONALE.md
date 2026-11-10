# Rationale

**Bug:** REPL entries were all evaluated under the same resource name `repl`. With identical source text in multiple entries, V8's code cache could confuse them (e.g. a repeated `import("fs")` after GC crashed). The fix gave each entry a unique name `REPL<N>`.

**Hunks (the release moved the helper to lib/internal/repl/utils.js):**
1. `lib/internal/repl/utils.js`: `getREPLResourceName()` now returns constant `'repl'` instead of `` `REPL${n++}` `` (corresponds to the fix's helper hunk plus the `self.eval(..., getREPLResourceName(), ...)` call-site hunks, which all use this helper).
2. `lib/repl.js`: stack-cleanup regexes `/^REPL\d+:\d+\r?\n/` and `/(\s+at\s+REPL\d+:)(\d+)/` reverted to `repl:` (corresponds to the two regex hunks).

**Failing tests:** parallel/test-repl-pretty-stack and parallel/test-repl-pretty-custom-stack (expected stacks contain `REPL<N>:*:*` but get `repl:*:*`; assertion mismatch). test-repl-dynamic-import still passes (GC-dependent). Failure was stable over two runs.
