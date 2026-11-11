# Adapted injection for Fix `allow_internal_unstable` for `(min_)specialization`

Fix: https://github.com/rust-lang/rust/commit/0529ccf341516b098554ccc82a77553159316c2a

# Rationale
File: compiler/rustc_trait_selection/src/traits/specialize/mod.rs, fn `specializes`.
Removed the `allows_unstable(sym::specialization / sym::min_specialization)` span check on the specializing impl,
so a crate without the specialization feature always returns `false`, even when the impl comes from a macro marked
`#[allow_internal_unstable(min_specialization)]`.
Re-expresses fix hunk `@@ -144,8 +144,22 @@ pub(super) fn specializes`, which replaced
`if !specialization_enabled && impl1_def_id.is_local() { return false; }` with span-based `allows_unstable` checks.
(In 1.99.1 only the specializing impl is checked, via `specialization_enabled_in`.)
