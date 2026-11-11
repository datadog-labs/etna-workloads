# Adapted injection for Normalize ADT fields in find_tails_for_unsizing

Fix: https://github.com/rust-lang/rust/commit/3df7882272c96a19bcff6269e4f9f0aba34b6c6f

# Rationale
File compiler/rustc_monomorphize/src/collector.rs, fn `find_tails_for_unsizing`, ADT arm.
Re-expresses the fix hunk `@@ -1075,21 +1074,23 @@ fn find_vtable_types_for_unsizing`, which added
`// We're getting a possibly unnormalized type, so normalize it.` and
`tcx.normalize_erasing_regions(typing_env, coerce_field.ty(*tcx, source_args))` (same for target).
I removed the normalization: the raw field types (`.skip_normalization()` needed on 1.99.1's Unnormalized wrapper) are recursed on, so alias types reach the tail computation unnormalized.
