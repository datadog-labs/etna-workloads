# Adapted injection for const validation: better error for maybe-null references

Fix: https://github.com/rust-lang/rust/commit/8328c3dada0c888b1c570f97314b3f697d4b2a96

# Rationale
In 1.99.1 the diagnostics are plain format strings (no messages.ftl / NullPtr variant), so only one hunk applies.

File `compiler/rustc_const_eval/src/interpret/validity.rs`, `check_safe_pointer` (null check after `scalar_may_be_null`).
Re-expresses fix hunk `@@ -538,8 +538,10 @@ ... ValidityVisitor` which added
`let maybe = !M::Provenance::OFFSET_IS_ADDR && matches!(scalar, Scalar::Ptr(..));` and `NullPtr { ptr_kind, maybe }`
(message "maybe-null reference/box"). The buggy parent always reports "encountered a null {ptr_kind}", even for pointers that are only maybe-null.
