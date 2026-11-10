# Adapted injection for collector: recursively traverse 'mentioned' items to evaluate their constants

Fix: https://github.com/rust-lang/rust/commit/712fe36611cf18306d3912beb5456cb0a7d0d276

# Rationale
File `compiler/rustc_monomorphize/src/collector.rs`, fn `collect_items_rec`: the final loop over `mentioned_items` now only recurses when `mode == CollectionMode::UsedItems` (via `.filter(|_| mode == ...)`). So items reached through "mentioned" collection are not traversed further, and constants in functions mentioned by dead code are never evaluated.

Re-expresses the fix hunk `@@ -459,8 +549,10 @@ fn collect_items_rec` / `@@ -474,10 +566,41 @@` which added recursion into mentioned items (`collect_items_rec(..., CollectionMode::MentionedItems)`) and the `mode`-aware traversal; pre-fix behaviour had no recursive traversal of mentioned items. (The rest of the fix, MIR `mentioned_items` field and pass, already exists in 1.99.1 in a different form.)
