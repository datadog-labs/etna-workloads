# Adapted injection for Fix removal span calculation of unused_qualifications suggestion

Fix: https://github.com/rust-lang/rust/commit/33bd453f3521ea3cfb67602eada912948b7aeb81

compiler/rustc_resolve/src/late.rs, lint_unused_qualifications: removal_span was `path[0].ident.span.until(seg.ident.span)` (seg = the first resolvable unqualified segment); now `finalize.path_span.until(path.last().unwrap().ident.span)`.
Re-expresses fix hunk `@@ -3928,8 +3929,7 @@` in late.rs: `removal_span: finalize.path_span.until(last_segment.ident.span)` together with `let last_segment = *path.last().unwrap();`. The removal span is computed relative to the last segment of the path rather than the segment that actually resolves unqualified, producing a wrong removal suggestion. (The context.rs/lint_defs hunks now live elsewhere in 1.99.1 and were not needed.)
