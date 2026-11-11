# Adapted injection for Honor current target when checking conditional compilation values

Fix: https://github.com/rust-lang/rust/commit/3455d66041eb1d766814b57608d7ae8f20c8b04e

# Rationale
File compiler/rustc_session/src/config/cfg.rs, `CheckCfg::fill_well_known_values` (target values loop, ~line 464).
Removed `.chain(iter::once(current_target.clone()))` so the loop is just `Target::builtins()`; the current session target (e.g. a target JSON) is no longer included in the well-known target_* values.
Re-expresses fix hunk `@@ -1229,6 +1229,7 @@ impl CrateCheckConfig` which added `.chain(iter::once(current_target.clone()))`. The signature/caller hunks (`fill_well_known(&sess.target)`) are left as-is (param now unused).
