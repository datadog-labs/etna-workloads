# Adapted injection for Populate effective visibilities in rustc_privacy

Fix: https://github.com/rust-lang/rust/commit/670f5b134e5dcb43e88d5c59f716058d320a2265

# Rationale
File compiler/rustc_privacy/src/lib.rs, `impl VisibilityLike for EffectiveVisibility::new_min`.
Re-expresses the fix hunk `@@ -421,7 +422,13 @@ impl VisibilityLike for Option<Level>` (`new_min`). In the buggy parent, a
def with no recorded effective visibility (private/unreachable) did not restrict the impl's computed visibility
(old: `public_at_level(def_id)` was None -> not considered reachable-by-effective-vis); the fix computes
min against the effective vis, treating missing as private. Here, a missing effective vis now returns `find.min`
unchanged instead of clamping to the private (restricted) visibility, so a private type in an impl
(`TryFrom<BarPriv>`) no longer lowers the impl's effective visibility, and the lints misfire.
