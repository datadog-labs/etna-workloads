# Adapted injection for fallback visibility for unexpected trait item

Fix: https://github.com/rust-lang/rust/commit/862368db9ff0db55940ef6543f246fd5d542a580

# Rationale
File compiler/rustc_resolve/src/late.rs, closure `feed_visibility` in the associated-item check (`check_trait_item`).
Fix hunk `@@ -3076,7 +3076,16 @@` replaced `let vis = this.r.tcx.visibility(def_id).expect_local();` with an `is_visible_locally()` check, a span_delayed_bug and a fallback to `Visibility::Public`. I restored the unconditional `.expect_local()`, which panics for a non-local-visible (private extern) trait item.
