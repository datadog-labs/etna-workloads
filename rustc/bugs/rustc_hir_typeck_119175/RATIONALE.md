# Adapted injection for fix: diagnostic for casting reference to slice

Fix: https://github.com/rust-lang/rust/commit/e6e195e27e6d5d12a135e4a40472c253bd63a77f

# Rationale
File compiler/rustc_hir_typeck/src/cast.rs, `report_cast_to_unsized_type`, `ty::Ref` arm.
Re-expresses fix hunk `@@ -576,25 +576,19 @@ impl<'a, 'tcx> CastCheck<'tcx>`: the fix removed `if self.cast_ty.is_trait() { suggestion } else { span_help("consider using an implicit coercion to `&{mtstr}{tstr}` instead") }` so the reference suggestion is always given. I restored that conditional (adapted to the current `span_suggestion_verbose`), so non-trait targets such as `[char]` get the wrong implicit-coercion help.
