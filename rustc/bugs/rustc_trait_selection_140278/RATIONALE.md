# Adapted injection for Don't use item name to look up associated item from trait item

Fix: https://github.com/rust-lang/rust/commit/1d0b3be659fe7128f4a66f593729e9c0627ed90a

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/fulfillment_errors.rs, closure computing `secondary_span` in the projection-mismatch reporter (E0271).

The fix hunk `@@ -1523,19 +1523,17 @@` replaced a lookup of the impl's associated item by name (`trait_assoc_ident` / `assoc.ident(self.tcx) == trait_assoc_ident`) with `assoc.trait_item_def_id == Some(proj.projection_term.def_id)`. That code has since moved: 1.99.1 uses `specialization_graph::assoc_def(.., proj.def_id())`, which matches by def id. I put back the name-based lookup there: find the impl item by comparing `ident` with the trait item's ident, so a macro-hygiene mismatch (impl item generated in a macro) makes the lookup fail and the "expected this to be `i64`" note disappears.
