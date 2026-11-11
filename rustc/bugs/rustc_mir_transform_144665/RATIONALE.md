# Adapted injection for Re-block SRoA on SIMD types

Fix: https://github.com/rust-lang/rust/commit/fe08ba0bae44b870fdda45a98ac51f435ddfc044

# Rationale
File compiler/rustc_mir_transform/src/sroa.rs, fn `escaping_locals` (closure `is_excluded_ty`).
Fix hunk `@@ -72,8 +72,12 @@ fn escaping_locals`: changed `tcx.is_lang_item(def.did(), LangItem::DynMetadata)` to `(def.repr().simd() || ...)`.
Reinjected by removing the `def.repr().simd()` check (and its comment), so SIMD ADTs are again SROA-expanded into arrays. (The `scalable()` check, added later, is kept.)
