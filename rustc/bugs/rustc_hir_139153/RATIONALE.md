# Adapted injection for Encode synthetic by-move coroutine body with a different DefPathData

Fix: https://github.com/rust-lang/rust/commit/897acc3e5d3622927118924fa920c8be0ef6f154

# Re-injection rationale: 897acc3e (by-move coroutine body DefPathData)

Bug brought back: the synthetic by-move coroutine body is encoded with `DefPathData::Closure`
again, so it shares the `{closure#N}` namespace with user-written closures under the same parent
(e.g. `main::{closure#0}::{closure#1}`). In incremental mode a user-written closure in a later
session can then get the same DefPath/DefPathHash as the synthetic body from the previous
session, which confuses the dep graph (ICE: query cycle, issue #139142).

## Hunk 1 — `compiler/rustc_hir/src/def.rs`, `DefKind::def_path_data`

Changed `DefKind::SyntheticCoroutineBody => DefPathData::SyntheticCoroutineBody` back to
`DefKind::SyntheticCoroutineBody => DefPathData::Closure`.

This is the fix hunk reversed exactly:
```
@@ -294,7 +294,7 @@ impl DefKind {
             DefKind::Closure => DefPathData::Closure,
-            DefKind::SyntheticCoroutineBody => DefPathData::Closure,
+            DefKind::SyntheticCoroutineBody => DefPathData::SyntheticCoroutineBody,
```

## Hunks 2+3 — `compiler/rustc_hir_id/src/definitions.rs` (`PerParentDisambiguatorState::continuing`, new helper) and `compiler/rustc_mir_transform/src/coroutine/by_move_body.rs` (`coroutine_by_move_body_def_id`)

These hunks are needed to adapt Hunk 1 to 1.99.1. They are not a separate bug.
When the fix landed, `Definitions` kept one disambiguator counter per (parent, data), shared by
every definition, so a synthetic body created with `DefPathData::Closure` got the next free
closure index after the coroutine, i.e. `{closure#1}`. That is visible in the fix's test
expectations, which rename `...-{closure#1}` to `...-{synthetic#0}`. In 1.99.1 the counter state
is per call site (`PerParentDisambiguatorState`), and `by_move_body.rs` creates a fresh one,
relying on `SyntheticCoroutineBody` being a unique DefPathData. If you only apply Hunk 1, the
synthetic body gets `{closure#0}`, which collides with the coroutine's own DefPath and ICEs with
"DefPathHash collision" on *every* async closure. That breaks far more than the original bug did.

So the `by_move_body.rs` call now passes a disambiguator state whose `Closure` counter continues
after the coroutine's disambiguator (`def_key(coroutine_def_id).disambiguator + 1`). The new
`continuing` constructor in `definitions.rs` exists only to seed that counter, because the
`next` field is private. Together these give the same `{closure#1}` numbering as the pre-fix
shared counter. All other fix hunks still compile and are unchanged: the `DefPathData::SyntheticCoroutineBody`
variant, its name `sym::synthetic`, the printer arm in `ty/print/mod.rs`, the mangling `'s'`/"s"
arms, and the `legacy.rs` arm. They are now just unreachable for this def kind, matching the
pre-fix behaviour, where every match on the def path data took the `Closure` arms. The other fix
hunks are a comment change in `context.rs` and `debug!` formatting in `graph.rs`, so they have no
behavioural effect and needed no change.
