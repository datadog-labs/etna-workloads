# Adapted injection for Mention implicit bounds from `#[derive(Clone)]` on moved value

Fix: https://github.com/rust-lang/rust/commit/7b62d97abdd38850621153e806cc7b0ee6ab4289

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/conflict_errors.rs, fn `suggest_cloning`, the `ty::Adt` branch.

Hunk 1 re-expresses fix hunk `@@ -1256,7 +1256,7 @@`: `&& let Some(local_did) = def.did().as_local()` goes back to `&& def.did().as_local().is_some()`.

Hunk 2 re-expresses fix hunk `@@ -1266,7 +1266,40 @@`. It removes the `for_each_relevant_impl` / `is_automatically_derived` scan and the "derived `Clone` adds implicit bounds" and "introduces an implicit `T: Clone` bound" labels. It also removes the "manually " wording, the alternate note message and the help. The code goes back to the unconditional label "consider implementing `Clone` for this type" and the note "if `{ty}` implemented `Clone`, you could clone the value".
