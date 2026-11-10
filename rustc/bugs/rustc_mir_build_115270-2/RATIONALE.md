# Adapted injection for Add note that str cannot be matched exhaustively

Fix: https://github.com/rust-lang/rust/commit/a293619caad49bb0e8d9a4d417bedf50f31d1b06

# Rationale
File: compiler/rustc_mir_build/src/thir/pattern/check_match.rs, fn report_non_exhaustive_match.
Removed the `else if ty.inner() == cx.tcx.types.str_ { err.note("`&str` cannot be matched exhaustively, ...") }` branch.
Re-expresses fix hunk `@@ -735,17 +735,21 @@ fn non_exhaustive_match` which added
`} else if ty == cx.tcx.types.str_ { err.note("`{ty}` cannot be matched exhaustively, so a wildcard `_` is necessary") }`.
The ptr-sized-integral refactor in that hunk is cosmetic and already present.
