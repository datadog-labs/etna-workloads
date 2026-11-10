# Adapted injection for fix `RebaseReason::Ambiguity`

Fix: https://github.com/rust-lang/rust/commit/36283bcb7e37b6e1cdf0c971f514a8212164a593

# Re-injection of the bug fixed by 36283bcb7e3 ("fix `RebaseReason::Ambiguity`", PR #147266)

## The bug
Before the fix, when a cycle head finished as ambiguous with no constraints, every provisional cache
entry that depended on it was rebased with
`*result = D::propagate_ambiguity(cx, input, *result)`. `propagate_ambiguity` got the certainty
from the entry's **own current result** (`from_result.unwrap().value.certainty`), not from the
cycle head. If the dependent entry's result was `Err(NoSolution)`, the `unwrap` panicked (ICE).
The fix passes the head's certainty along (`RebaseReason::Ambiguity(info)` /
`propagate_ambiguity(cx, input, info)`).

In 1.99.1 this code has been rewritten. `propagate_ambiguity` is gone, `RebaseReason::Ambiguity(kind)`
carries the head's `AmbiguityKind` (`Certainty`), and dependent entries are kept only if their own
result is already ambiguous with the same kind. The fixpoint-overflow path now uses
`RebaseReason::Ambiguity(D::FIXPOINT_OVERFLOW_AMBIGUITY_KIND)` too, instead of a separate `Overflow` variant.

## Hunks changed

### 1. compiler/rustc_type_ir/src/search_graph/mod.rs, `trait Delegate`
Adds back `fn propagate_ambiguity(cx, for_input, from_result: <Self::Cx as Cx>::Result) -> Result`,
which takes the entry's result rather than ambiguity info. Re-expresses (in reverse) this fix hunk:
```
@@ -96,11 +97,13 @@ pub trait Delegate: Sized {
     fn propagate_ambiguity(
         cx: Self::Cx,
         for_input: <Self::Cx as Cx>::Input,
-        from_result: <Self::Cx as Cx>::Result,
+        ambiguity_info: <Self::Cx as Cx>::AmbiguityInfo,
```

### 2. compiler/rustc_next_trait_solver/src/solve/search_graph.rs, `impl Delegate for SearchGraphDelegate`
Adds back the buggy `propagate_ambiguity`, which unwraps the entry's own result to get the certainty.
Re-expresses (in reverse) this fix hunk:
```
@@ -99,19 +99,23 @@ where
     fn propagate_ambiguity(
         cx: I,
         for_input: CanonicalInput<I>,
-        from_result: QueryResult<I>,
+        certainty: Certainty,
     ) -> QueryResult<I> {
-        let certainty = from_result.unwrap().value.certainty;
         response_no_constraints(cx, for_input, certainty)
```
(Adapted to today's result type `(QueryResult<I>, AccessedOpaques<I>)`, so it is `from_result.0.unwrap()`.)

### 3. compiler/rustc_type_ir/src/search_graph/mod.rs, `SearchGraph::rebase_provisional_cache_entries`
In the `RebaseReason::Ambiguity(_)` arm (the arm reached when a head is ambiguous with no
constraints), the head's kind is ignored again and the entry's result is overwritten with
`D::propagate_ambiguity(cx, input, *result)`, as before the fix. Re-expresses (in reverse):
```
@@ -1029,8 +1032,8 @@ impl<D: Delegate<Cx = X>, X: Cx> SearchGraph<D, X> {
-                        RebaseReason::Ambiguity => {
-                            *result = D::propagate_ambiguity(cx, input, *result);
+                        RebaseReason::Ambiguity(info) => {
+                            *result = D::propagate_ambiguity(cx, input, info);
```
To keep unrelated behaviour intact, the fixpoint-overflow use of `Ambiguity`
(`kind == D::FIXPOINT_OVERFLOW_AMBIGUITY_KIND`) keeps today's logic. Before the fix, that case was
the separate `RebaseReason::Overflow` arm, which the fix did not touch.

### 4. Plumbing: `cx` parameter on `rebase_provisional_cache_entries` and its four call sites
The pre-fix function took `cx: X` (see the fix's context lines
`@@ -951,7 +954,7 @@ ... fn rebase_provisional_cache_entries(&mut self, cx: X, ...` and
`@@ -1355,8 +1359,12 @@ ... self.rebase_provisional_cache_entries(cx, &stack_entry, RebaseReason::Ambiguity)`).
It is needed again so `propagate_ambiguity` can build a response. `cx` was added to
`#[instrument(skip(...))]` because `X` is not `Debug`.

Not reproduced: the fix's `interner.rs` hunks (`type AmbiguityInfo = Certainty`) and the
`#[instrument]` on `reached_fixpoint`. In 1.99.1 the `AmbiguityKind` associated type already exists and is
still used by `is_ambiguous_result`, and the instrument attribute only affects tracing.
