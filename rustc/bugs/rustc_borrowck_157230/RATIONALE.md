# Adapted injection for borrowck: avoid ICE describing fields on generic params

Fix: https://github.com/rust-lang/rust/commit/23144573a871726bca6e271ff80168cf5acba640

# Rationale
File compiler/rustc_borrowck/src/diagnostics/mod.rs, fn describe_field_from_ty.
Fix hunk `@@ -525,6 +525,7 @@` added `ty::Param(_) => Some(field.index().to_string()),`.
In 1.99.1 the match already has a catch-all `_ => Some(field.index().to_string())`, so the fix was
re-expressed by turning that catch-all into `bug!(...)`: type params (e.g. Box<T> boxed_ty) are no longer
handled, so describing `self.0` on a generic param ICEs again.
