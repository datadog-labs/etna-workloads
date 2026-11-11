# Adapted injection for Fix #131977 parens mangled in shared mut static lint suggestion

Fix: https://github.com/rust-lang/rust/commit/cc0ec046b1f7a1b708454cf8d6e33fceee44420d

# static_mut_refs.rs, StaticMutRefs::check_expr (AddrOf arm)
Fix hunk `@@ -71,13 +71,24 @@ impl LateLintPass for StaticMutRefs` added computing a suggestion span that skips leading
whitespace/`(` bytes (`exclude_n_bytes`, `err_span.with_lo(err_span.lo() + BytePos(exclude_n_bytes))`).
Reinjected bug: sugg_span is again `static_mut.err_span.with_hi(ex.span.lo())`, so with `(&TEST)` the suggestion
span includes the opening parens and the `&raw const` replacement drops them (mangled parens).
(The BytePos import hunk is still needed by other code in 1.99.1, so left alone.)
