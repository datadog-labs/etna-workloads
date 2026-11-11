# Adapted injection for Async drop - type instead of async drop fn and incorrect drop signature don't ICE now

Fix: https://github.com/rust-lang/rust/commit/f023a69f32352531a8da2f43e2ca4cd087317f8c

# Rationale

## Background
The fix (f023a69f) guarded the lookup of the `AsyncDrop::drop` implementation in
`build_async_drop` (compiler/rustc_mir_transform/src/elaborate_drop.rs): the first
associated item of the selected `impl AsyncDrop` was used only if it was an `AssocFn`
whose generics matched the impl args (`check_args_compatible`). Without the check, an
impl containing a type, or a `drop` with an extra (impl-Trait) generic parameter,
ICEs (#140484, #140500).

In 1.99.1 that code was later rewritten by ed0471b5450 ("Do not resove trait impl during
elaboration"), which uses the *trait's* `AsyncDrop::drop` item with `[drop_ty]` args, so
the impl item is never looked up and the fix's hunk has no textual counterpart.

## Hunk 1 — `elaborate_drop.rs`, `DropCtxt::build_async_drop` (call_destructor_only branch)
Re-expresses fix hunk:

    @@ -254,8 +255,19 @@ where
    -            let Some(drop_fn_def_id) =
    -                tcx.associated_item_def_ids(drop_trait).into_iter().nth(0).copied()
    +            let Some(drop_fn_def_id) = tcx
    +                .associated_item_def_ids(drop_trait)
    +                .first()
    +                .and_then(|def_id| {
    +                    if tcx.def_kind(def_id) == DefKind::AssocFn
    +                        && tcx.check_args_compatible(*def_id, trait_args)

To bring back the parent behaviour I restored the parent's context for that line: the
`AsyncDrop` impl is selected via `codegen_select_candidate` (giving `drop_trait` = impl
DefId and `trait_args` = impl args), and the drop fn is taken as the impl's first
associated item *unchecked* (`.into_iter().nth(0).copied()`, exactly the pre-fix line).
Empty-impl case keeps the #140974 fallback (delayed bug + plain `Drop` terminator),
as in the parent. The future type (`fn_sig(...).instantiate(tcx, trait_args)`) and the
`Operand::function_handle(..., trait_args, ...)` call now use the impl's def id/args, as
in the parent (small adjustments needed to thread `trait_args` through).
The async_drop_in_place branch is unchanged in behaviour (args = `[drop_ty]`).

## Hunk 2 — `use rustc_middle::{bug, span_bug, traits};`
Import needed by hunk 1 (`traits::ImplSource`). The fix's `@@ -1,6 +1,7 @@` hunk added
`use rustc_hir::def::DefKind;`; the reverted code no longer uses `DefKind` (1.99.1 does not
import it), so nothing to remove there.
