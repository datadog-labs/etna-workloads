# Rationale

Fix hunk: `UnionEquivalentOrderingBuilder::try_add_ordering` dropped the `constants.is_empty() &&` guard in front of `properties.ordering_satisfy(ordering)`.

In 55.2.0 the code lives in `datafusion/physical-expr/src/equivalence/properties/union.rs`. I restored the guard:

```rust
if constants.is_empty() && properties.ordering_satisfy(ordering.clone())? {
```

This is the pre-fix condition. When the source has constants, an ordering that already satisfies the target is no longer pushed as-is. It goes to the constant-augmentation path instead, which can fail to find an augmented ordering. The union then loses its output ordering, and the sanity checker rejects the plan.

Oracle: `union_by_name.slt`. The `UNION ALL BY NAME ... ORDER BY` cases, which the fix changed from `query error` to real results, should fail again with a SanityCheckPlan error.
