# Adapted injection for Remove invalid lint when there is a generic argument in prefix path

Fix: https://github.com/rust-lang/rust/commit/c9be1a71b69fb99f9a10b1ba058138d374b5b3a9

# Rationale
File: compiler/rustc_resolve/src/late.rs, fn `lint_unused_qualifications`.
Fix hunk `@@ -3944,11 +3944,12 @@` added `prev_segs.iter().all(|seg| !seg.has_generic_args)` to skip the lint when a prefix segment has generic args. In 1.99.1 this is expressed by truncating the checked segments at the first generic-arg segment (`end_pos = position(has_generic_args)+1`). I replaced that with `end_pos = path.len()`, so prefix segments with generic args are linted again (e.g. `Option::<Option<()>>::None` suggests removing `Option::<..>::`).
