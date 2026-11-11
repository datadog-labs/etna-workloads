# Adapted injection for Suggests turbofish in patterns

Fix: https://github.com/rust-lang/rust/commit/049c728c60f7c950b7185f0f277609694a8e2a16

# Rationale
One hunk: compiler/rustc_parse/src/parser/pat.rs, `parse_pat_ident`.
In 1.99.1 the fix's recovery (path.rs `else if style == PathStyle::Pat && check_noexpect(&token::Lt) && look_ahead(1, can_begin_type)` returning `GenericArgsInPatRequireTurbofishSyntax`, plus the `@@ -805` pat.rs lookahead `!(look_ahead(1, Lt) && look_ahead(2, can_begin_type))` in `can_be_ident_pat`) has been consolidated into a block in `parse_pat_ident` that checks `check_noexpect(&token::Lt) && look_ahead(1, can_begin_type)` and emits the turbofish error. I removed that block, restoring the pre-fix behaviour: `Foo<T>(x,y)`, `let caller<F>` etc. give the generic "expected one of ..., found `<`" error instead of the turbofish suggestion. This re-expresses the fix's added path.rs hunk `@@ -382,6 +382,14 @@` (`return Err(... GenericArgsInPatRequireTurbofishSyntax {...})`).
