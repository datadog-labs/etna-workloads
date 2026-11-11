# Adapted injection for Don't suggest changing {ImmRef,MutRef} implicit self to be mutable

Fix: https://github.com/rust-lang/rust/commit/57e67e4ab21b466158a3e7eeaf598baefc18ad72

Hunk: compiler/rustc_borrowck/src/diagnostics/mutability_errors.rs, report_mutability_error (closure-upvar branch).
Fix hunk `@@ -416,12 +416,28 @@` added `if upvar_ident.name == kw::SelfLower { ... !matches!(implicit_self, ImmRef|MutRef) ... }` guarding the "consider changing this to be mutable" suggestion. Re-injected bug: removed that guard, so the suggestion is always emitted, including for `&self`/`&mut self`.
