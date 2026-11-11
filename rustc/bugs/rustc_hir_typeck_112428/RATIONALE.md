# Adapted injection for Structurally resolve correctly in check_pat_lit

Fix: https://github.com/rust-lang/rust/commit/54fb5a48b968b3a329ceeb57226d9ac60f983f04

# pat.rs, FnCtxt::check_pat_lit (byte-string literal branch)
Fix hunk `@@ -393,9 +393,8 @@ impl FnCtxt` replaced the unresolved `inner_ty` slice check with
`self.structurally_resolved_type(span, inner_ty).is_slice()`.
In 1.99.1 that is `self.resolve_vars_with_obligations(inner_ty).is_slice()` (after `structurally_resolve_type(expected)`).
Re-injected: removed both the structural resolution of `expected` and the resolution of `inner_ty`, so the check is the raw `inner_ty.is_slice()` on an unresolved type (next-solver alias/infer var is not seen as a slice).
(Resolving only inner_ty did not make the test fail on 1.99.1, since expected is resolved already.)
