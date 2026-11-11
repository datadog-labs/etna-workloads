# Adapted injection for Don't suggest adding the unexpected cfgs the build-script it-self

Fix: https://github.com/rust-lang/rust/commit/1c7859e117b77134650663b4c470dcfea7fe1468

File: compiler/rustc_attr_parsing/src/check_cfg.rs (moved from rustc_lint in 1.99.1), fn `cargo_help_sub`.
Re-expresses fix hunk `@@ -42,6 +42,22 @@ fn to_check_cfg_arg` (added `cargo_help_sub` with the
`crate_name == "build_script_build"` check choosing `lint_cfg` vs `lint_cfg_and_build_rs`).
The buggy parent always suggested both Cargo.toml and build.rs (`UnexpectedCfgCargoHelp::new`); now the
build-script check is dropped and `lint_cfg_and_build_rs` is always used. The other fix hunks (call sites, lints.rs enum) are unchanged since the helper is shared by the call sites.
