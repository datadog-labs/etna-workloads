# Adapted injection for Don't structurally resolve during method ambiguity in probe

Fix: https://github.com/rust-lang/rust/commit/afe36507e84e8b7805717bc1c5054dcf4346df92

# Hunk: compiler/rustc_hir_typeck/src/method/probe.rs, FnCtxt::probe_op (opt_bad_ty handling)
Fix hunk `@@ -448,15 +449,23 @@` replaced `let ty = self.structurally_resolved_type(span, ty.value);` with
`resolve_vars_if_possible` (comment: "don't call `structurally_resolved_type`"). In 1.99.1 the code was
restructured; the equivalent is `let ty = ty.value;` and a comment saying not to call structurally_resolve_type.
Re-injected: drop that comment and call `self.structurally_resolve_type(span, ty.value)` on the bad type again,
which processes obligations in the local FnCtxt and can make the ambiguity vanish / report at the wrong place.
