# Adapted injection for Don't inline integer literals when out of range

Fix: https://github.com/rust-lang/rust/commit/857f5dd475ca33c825446fb3235e39b928dbf998

# Rationale
File compiler/rustc_ast_lowering/src/format.rs, `LoweringContext::try_inline_lit`.
Fix hunk `@@ -48,10 +48,104 @@ impl<'hir> LoweringContext` added range checks (`(n <= max_literal).then_some(...)`, i32::MAX for unsuffixed, int_ty_max/uint_ty_max for suffixed) in try_inline_lit. Re-injected bug: the `Ok(LitKind::Int(n, _))` arm now always inlines `Symbol::intern(&n.to_string())` regardless of range, so out-of-range literals (e.g. 4294967296 unsuffixed, 256u8) get inlined into the format string instead of being left as arguments (so the overflow lint is lost / wrong output).
(The int_ty_max/uint_ty_max helpers remain, now unused.)
