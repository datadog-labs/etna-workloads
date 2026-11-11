# Adapted injection for Don't ICE on placeholder consts in deep reject

Fix: https://github.com/rust-lang/rust/commit/1ce6e2bd339d0ea4d292d3afde482050c1f34497

# Rationale
File: compiler/rustc_type_ir/src/fast_reject.rs, fn `consts_may_unify_inner` (moved from rustc_middle's DeepRejectCtxt).
Fix hunk `@@ -359,6 +360,9 @@` added `ty::ConstKind::Placeholder(_) => false` ("Placeholder consts don't unify with anything on their own") and hunk `@@ -371,7 +375,7 @@` removed Placeholder from the `bug!("unexpected obl const")` arm.
Re-injected: the `lhs` Placeholder arm now panics with "unexpected obl const" instead of comparing placeholders.
