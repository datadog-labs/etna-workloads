# Adapted injection for Do not const pop unions

Fix: https://github.com/rust-lang/rust/commit/633c92cd6de9e269b9c5b10f341fc10280503f0c

# Rationale
File: compiler/rustc_mir_transform/src/known_panics_lint.rs, fn `CanConstProp::check` (the loop over `can_const_prop`).
Removed the `else if ty.is_union() { *val = ConstPropMode::NoPropagation; }` branch.
The fix hunk `@@ -585,20 +585,32 @@ ... Aggregate(ref kind, ref fields)` added `if let AggregateKind::Adt(_, _, _, _, Some(_)) = **kind { return None; }` so union aggregates are never const-popped. In 1.99.1 that guard is gone from eval_rvalue and union locals are protected by the `ty.is_union()` NoPropagation instead; removing it restores the parent behaviour (union aggregates get const-propagated, causing the ICE).
