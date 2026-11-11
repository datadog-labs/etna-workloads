# Adapted injection for Ensure that we don't try to access fields on a non-struct pattern type in diagnostic

Fix: https://github.com/rust-lang/rust/commit/5f04f98c9aaf04e5f670e04dc12d4665489859fd

Fix hunk: `@@ -1130,7 +1130,9 @@ ... detect_missing_binding_available_from_pattern`: added
`if let DefKind::Struct = self.r.tcx.def_kind(*def_id) && let Some(fields) = self.r.field_idents(*def_id)`.
In 1.99.1 the call site (late/diagnostics.rs, detect_missing_binding_available_from_pattern) has guard `DefKind::Struct | DefKind::Variant`; I removed it so it is just `if let Some(fields) = self.r.field_idents(*def_id)` (old behaviour).
That alone no longer failed, because `Resolver::field_idents` (rustc_resolve/src/lib.rs) also guards non-local defs by def_kind (Struct|Union|Variant). I removed that guard (non-local arm unconditional), so a non-struct def (the assoc type Iterator::Item) reaches associated_item_def_ids and panics in metadata decoder, as in #135209.
