# Adapted injection for fix for `Self` not respecting tuple Ctor privacy

Fix: https://github.com/rust-lang/rust/commit/be44860ab94f9e469d6f02232d3064a1049c47ba

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/_impl.rs, fn instantiate_value_path (the `Self` ctor branch, `Some(adt_def) if adt_def.has_ctor()`).
Removed the block
    // Check the visibility of the ctor.
    let vis = tcx.visibility(ctor_def_id);
    if !vis.is_accessible_from(tcx.parent_module(hir_id).to_def_id(), tcx) { emit_err(CtorIsPrivate{..}) }
which re-expresses fix hunk `@@ -1207,6 +1208,12 @@ impl<'a, 'tcx> FnCtxt<'a, 'tcx>` (added exactly this check). Also dropped the now-unused `CtorIsPrivate` import (fix's `use crate::errors::CtorIsPrivate` hunk). The diagnostic struct/ftl remain (unused-but-harmless; build ok).
