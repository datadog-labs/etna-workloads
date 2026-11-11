# Adapted injection for fix: more descriptive error message for enum to integer

Fix: https://github.com/rust-lang/rust/commit/da133533ed1d16275a523aa09b06b1c459691f6a

# Rationale
File: compiler/rustc_hir_typeck/src/cast.rs, fn `report_cast_error`, arm `NeedViaThinPtr | NeedViaPtr`.
Fix hunk `@@ -291,12 +291,32 @@` added a branch (`!matches!(self.expr.kind, ExprKind::AddrOf(..)) && Ref(enum payloadfree)`) that
suggests dereferencing for `&Enum as int`; before it only `cast through a raw pointer first` help was given.
In 1.99.1 the branch exists (with different wording), so I disabled it (`if false && let ...`), restoring the old
generic "cast through a raw pointer first" help for `&Enum as u8`.
