# Adapted injection for report pat no field error no recoverd struct variant

Fix: https://github.com/rust-lang/rust/commit/07e6dd95bd84bd506a0a04f2054ff82c681be928

# Rationale
1.99.1 already has the `tainted: Option<ErrorGuaranteed>` / `has_errors()` machinery, so I removed two of the fix's uses of it.

1. compiler/rustc_hir_typeck/src/expr.rs, `check_field` (the `ty::Adt(base_def, args) if !base_def.is_enum()` arm). Removed `if let Err(guar) = base_def.non_enum_variant().has_errors() { return Ty::new_error(..) }`. This re-expresses the fix hunk `@@ -2345,6 +2343,11 @@` ("we don't care to report errors for a struct if the struct itself is tainted"). Without it, field access on a parser-recovered struct is checked again and ICEs (issue 126744).
2. compiler/rustc_hir_typeck/src/pat.rs, `check_struct_pat_fields`. Removed `variant.has_errors()?;` before `error_inexistent_fields`. This re-expresses the pat.rs hunk `@@ -1531,9 +1531,11 @@` (`variant.has_errors()?;`). Without it, inexistent-field errors are reported for recovered structs.
