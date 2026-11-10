# Adapted injection for Try to use approximate placeholder regions when outputting an AscribeUserType error in borrowck

Fix: https://github.com/rust-lang/rust/commit/35dd0c90494909106736093199dfae84f229f747

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/bound_region_errors.rs, fn try_extract_error_from_region_constraints.
Fix hunk `@@ -404,19 +408,41 @@ fn try_extract_error_from_region_constraints`: the fix added a second pass
(`if info.is_none() { info = ...find_map(|..| check(constraint, cause, false)) }`) using approximate placeholder matching (`matches`).
In 1.99.1 this is `find_culprit(true).or_else(|| find_culprit(false))?`; I changed it to `find_culprit(true)?`, restoring the old exact-only lookup, so no cause is found and the nice AscribeUserType error is lost.
The other fix hunks are debug!/Debug-derive/instrument-only and have no behavioural effect.
