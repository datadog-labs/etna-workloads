# Adapted injection for Detect unused structs which derived Default

Fix: https://github.com/rust-lang/rust/commit/6997b6876d62b7c42faf12af3164c87ab733be13

# Rationale
Hunk: compiler/rustc_passes/src/dead.rs, `check_impl_or_impl_item_live`.
Fix hunk `@@ -400,31 @@ impl<'tcx> MarkSymbolVisitor<'tcx>` (plus `#[rustc_trivial_field_reads]` on `Default`) made derived `Default` impls ignored in dead-code analysis, so unused structs deriving Default get reported. In 1.99.1 the attribute/ignore code is gone from Default, and liveness of trait impl items requires the self ADT to be live. I re-introduce the old behaviour: automatically derived `Default` impls/items are always live (early `return true`), so their body marks the struct live and `struct T` is no longer reported.
