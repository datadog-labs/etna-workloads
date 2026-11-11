# Adapted injection for detect cycles during valtree construction for self-referential consts

Fix: https://github.com/rust-lang/rust/commit/c61c52f51de4d41929a9a20f5921afa73e5718cf

# Rationale
File: compiler/rustc_const_eval/src/const_eval/valtrees.rs, fn `const_to_valtree_inner`.
Removed the `settled.get(place)` early return and the `visited.contains(place) => Err(ValTreeCreationError::CyclicConst)` check.
Re-expresses the fix hunk `@@ -57,39 +60,53 @@ fn branches` / const_to_valtree_inner, which added:
    if let Some(&result) = settled.get(place) { return result; }
    if visited.contains(place) { return Err(ValTreeCreationError::CyclicConst); }
Without it, self-referential consts recurse infinitely (stack overflow, issue #144719).
The rest of the fix (plumbing, error variant, diagnostic) is left in place; it is now just unused on that path.
