# Adapted injection for gvn: avoid creating overlapping assignments

Fix: https://github.com/rust-lang/rust/commit/d2e5a3d131bd5a4ac92c0e6cfd3c49b5b6d44ab6

# Rationale
Hunk: compiler/rustc_mir_transform/src/gvn.rs, `try_as_place` (Deref handling): added `Value::Address { .. } => {}` to the match that decides whether a new `Deref` may be introduced.

Re-expresses fix hunk `@@ -982,12 +984,16 @@ simplify_aggregate_to_copy`, which added the guard
`if lhs.as_local().is_some() { ... *rvalue = Rvalue::Use(Operand::Copy(place)) }` so that
`*a = copy (*b)` (possibly overlapping aliases) is never created. In 1.99.1 that guard
is gone: the `lhs` parameter is unused in `simplify_rvalue`, and the equivalent protection is that
`try_as_place` only introduces a `Deref` of an immutable Argument. Letting it introduce a Deref of
a `Value::Address` pointer restores the pre-fix behaviour: the aggregate `(*_2) = Adt::Some(copy _3)`
is turned into `(*_2) = copy (*_4)` with `_4 = &(*_2)`, an overlapping assignment.
