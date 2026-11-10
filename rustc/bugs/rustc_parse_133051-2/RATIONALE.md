# Adapted injection for Increase accuracy of `if` condition misparse suggestion

Fix: https://github.com/rust-lang/rust/commit/04fe8391775683e58d861f28678bf80940c91f44

# Rationale
File: compiler/rustc_parse/src/parser/stmt.rs, fn `suggest_fixes_misparsed_for_loop_head` (in 1.99.1 the fix's match was factored out of `error_block_no_opening_brace_msg`).
Re-expresses fix hunk `@@ -514,15 +515,94 @@ ... fn error_block_no_opening_brace_msg`: the fix replaced the single unconditional
`e.multipart_suggestion("try placing this code inside a block", ...)` with a `match (&self.token.kind, &stmt.kind)` choosing method-call/field-access/block suggestions.
I collapsed the match back to the unconditional block-wrapping multipart suggestion (pre-fix behaviour, old message text).
The `let prev = self.prev_token.span;` hunk (`@@ -475,6 +475,7 @@`) is left; `prev.between(sp)` is still passed but unused.
