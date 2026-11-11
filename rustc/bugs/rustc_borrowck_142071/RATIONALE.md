# Adapted injection for apply_member_constraints: fix placeholder check

Fix: https://github.com/rust-lang/rust/commit/cde14e65bf4d072ab38cf7e909113979b12ae044

# Rationale
The code moved: the check lives in `apply_member_constraint` (compiler/rustc_borrowck/src/region_infer/opaque_types/member_constraints.rs), using a `RegionCtxt` accessor.

1. member_constraints.rs `apply_member_constraint`: bail-out check changed from `rcx.max_placeholder_universe_reached(member).is_root()` back to `rcx.max_nameable_universe(member).is_root()`. Re-expresses fix hunk `@@ -713,7 +713,7 @@` in region_infer/mod.rs (`- if !self.max_nameable_universe(scc).is_root()` / `+ ... max_placeholder_universe_reached`).
2. region_ctxt.rs: added `RegionCtxt::max_nameable_universe` (and `#[allow(dead_code)]` on the placeholder accessor, now unused). Re-expresses the fix's addition of `max_placeholder_universe_reached` accessor in `@@ -1376,6 +1376,13 @@` (the accessor being unused again in the buggy version).
