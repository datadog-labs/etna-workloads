# Adapted injection for fix: correct the arg for 'suggest to use associated function syntax' diagnostic

Fix: https://github.com/rust-lang/rust/commit/e4cfe038adffb0cf5785d7c95f809364c6a39f5f

# Rationale
File: compiler/rustc_hir_typeck/src/method/suggest.rs, fn suggest_associated_call_syntax (the `first_arg` closure).

Fix hunk `@@ -1591,10 +1591,12 @@` changed the check from `if first.peel_refs() == rcvr_ty.peel_refs() { None } else { Some(ref prefix) }`
to `if first.peel_refs() == impl_ty { Some(..) } else { None }`.
In 1.99.1 the code is `first_ty == self_ty || first_ty == Self param`; I restored the old buggy condition:
compare against the receiver type (peeled) and suggest taking the first arg only when it differs. So `A::hello(1)` wrongly gets the receiver `_a` inserted.
