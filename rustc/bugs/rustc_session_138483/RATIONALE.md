# Adapted injection for Target modifiers fix for bool flags without value

Fix: https://github.com/rust-lang/rust/commit/6ccaea19895cc8c0861f3a8707f888a15f8be3a1

# Hunk
compiler/rustc_session/src/options.rs, `build_options`: when a target-modifier flag is parsed, only record it
when a value is present (`if let Some(tmod) = *tmod && let Some(value) = value { insert(tmod, value.to_string()) }`).
Re-expresses fix hunk `@@ -681,10 +686,9 @@ fn build_options<O: Default>(`, which replaced that with
`let v = value.map_or(String::new(), ToOwned::to_owned); target_modifiers.insert(tmod, v);`.
Result: bool flags given without a value (`-Zreg-struct-return`) are not recorded as target modifiers, so mismatches go undetected.
