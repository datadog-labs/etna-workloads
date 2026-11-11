# Adapted injection for Detect unused struct impls pub trait

Fix: https://github.com/rust-lang/rust/commit/1299aa7c18377dfbe43095b5be4ff2c0161eae8d

# Rationale
File: compiler/rustc_passes/src/dead.rs, fn `MarkSymbolVisitor::check_impl_or_impl_item_live`.
The dead-code pass was rewritten since the fix, so the old `check_item` code no longer exists. The fix's hunk in `check_item` (`@@ -683,16 +733,33 @@`) added `&& (ty_is_pub || may_construct_self)`. That condition stopped pub-trait methods in impls on private, unused ADTs from being seeded live. Without it, such methods were always live.
The equivalent in 1.99.1 is the "self type is live" check in `check_impl_or_impl_item_live`. I added an early `return true` for public `AssocFn` impl items. This skips the ADT-liveness check, so the old behaviour is back: pub trait methods keep an unused struct/enum alive.
