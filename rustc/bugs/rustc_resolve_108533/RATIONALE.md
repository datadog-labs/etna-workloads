# Adapted injection for diagnostics: avoid querying `associated_item` in the resolver

Fix: https://github.com/rust-lang/rust/commit/f058bb0fcfeef3ebb0da19b2399f575c3aa9c3e8

# Rationale
Fix: stop using `tcx.def_kind_descr` (which queries `associated_item` and cycles back into the resolver) in resolve diagnostics; use `DefKind::descr`. I restore the old `tcx.def_kind_descr` calls in `compiler/rustc_resolve/src/diagnostics/impls.rs`:

1. `report_conflict`: container descr, `ModuleKind::Def(kind, def_id, ..) => self.tcx.def_kind_descr(kind, def_id)`. Re-expresses hunk `@@ -189,7 +189,9 @@ ... let container = match parent.kind` (`kind.descr(parent.def_id())`).
2. Suggestion-kind site (`let kind = self.tcx.def_kind_descr(kind, def_id)`), the same pattern (the fix's second hunk, `found(kind.descr(id))`, was nearby-style code).
3. The hunk `@@ -1804,7 +1806,9 @@ ... Res::Def(kind, id) => found(kind.descr(id))` is re-expressed in the import-error "expected {}, found {} `{ident}` in {parent}" message (`report_path_resolution_error`). It now uses `self.tcx.def_kind_descr(kind, id)` for `Res::Def`. This is the site the oracle hits.
