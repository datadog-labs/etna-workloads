# Adapted injection for Do not write user type annotation for const param value path

Fix: https://github.com/rust-lang/rust/commit/8ab05adc37667c3169fb120b3a9f53be9a909c3b

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/_impl.rs, fn `write_user_type_annotation_from_args`.
Removed the early return for `DefKind::ConstParam` (the fix's hunk `@@ -220,6 +220,13 @@` added
"Don't write user type annotations for const param types ... if matches!(def_kind, ConstParam) { return; }").
Without it, an annotation is written for const param paths in patterns, ICEing/misreporting (#138048).
