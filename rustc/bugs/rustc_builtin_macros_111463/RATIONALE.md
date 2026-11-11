# Adapted injection for Better diagnostics for `env!` where variable contains escape

Fix: https://github.com/rust-lang/rust/commit/2555f3bbcf0c42e2405912ff93318107596f698b

# Rationale
File: compiler/rustc_builtin_macros/src/env.rs, fn `expand_env`, NotPresent arm.
Re-expresses the fix hunk `@@ -80,10 +81,15 @@` (`var: *original_var` replacing `var`): the fix reports the
original source literal symbol (unescaped text kept as written, e.g. `\t`). The bug reports the
processed (unescaped) var value instead. In 1.99.1 the code uses `symbol` (original literal); I changed the
`CargoEnvVarTypo`, `CargoEnvVar`, `CustomEnvVar` diagnostics to use `var_sym` (the unescaped value from
`expr_to_string`, saved before `var` is shadowed by `as_str()`), so `env!("\t")` prints a literal tab.
