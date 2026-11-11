# Adapted injection for `loop_match`: suggest extracting to a `const` item

Fix: https://github.com/rust-lang/rust/commit/730d33dd6476ebe4342da9e14c1079f277e1ee74

# Rationale
File compiler/rustc_mir_build/src/builder/scope.rs, fn `break_const_continuable_scope`-area (const_continue lowering).
Re-expresses hunk `@@ -887,7 +890,27 @@`: the fix replaced `_ => self.as_constant(&self.thir[value])` with an explicit
Literal/NonHirLiteral/ZstLiteral/NamedConst arm plus an `other =>` arm emitting `ConstContinueNotMonomorphicConst`
(with "try extracting into a const item" help). I restored the old catch-all `_ => self.as_constant(..)`, so non-const
expressions fall back to the generic "too generic" error without the suggestion. Also dropped the now-unused import
(hunk `@@ -100,7 +100,9 @@`). The new diagnostic types/ftl entries are left in place (unused, only warnings).
