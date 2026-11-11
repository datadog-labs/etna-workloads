# Adapted injection for Support opaque_types_defined_by for SyntheticCoroutineBody

Fix: https://github.com/rust-lang/rust/commit/5e31cd30aae245aaa1374e12521667b8c728402d

# Rationale
File compiler/rustc_ty_utils/src/opaque_types.rs, fn opaque_types_defined_by.
In 1.99.1 the closure/inline-const arm was folded into an early return `if tcx.is_typeck_child(item)` (which includes SyntheticCoroutineBody). Fix hunk 1 (`@@ -321,7 +321,10 @@`, `DefKind::Closure | DefKind::InlineConst | DefKind::SyntheticCoroutineBody => {...}`) and hunk 2 (`@@ -343,8 +346,7 @@`, removing `| DefKind::SyntheticCoroutineBody` from the span_bug arm) are reversed by excluding SyntheticCoroutineBody from the early return, so it reaches the span_bug arm (which still lists it) -> ICE as before the fix. The explanatory comment was removed too.
