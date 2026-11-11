# Adapted injection for fix ICE on specific malformed asm clobber_abi

Fix: https://github.com/rust-lang/rust/commit/3dc793e625a1b566ca37ba0b12281f9cfb4eb473

# Hunk: compiler/rustc_parse/src/parser/asm.rs, parse_clobber_abi
(Moved from rustc_builtin_macros/src/asm.rs in 1.99.1.)
Fix hunk `@@ -379,16 +379,12 @@ fn parse_clobber_abi`: `loop {` -> `while !p.eat(CloseDelim(Parenthesis)) {`, and removal of the
"If the non-string literal is a closing paren..." `if p.eat(CloseParen) { break; }` in the Err arm.
I restored the old form: `loop {` plus the eat-close-paren check inside the Err arm, so a non-string literal followed by `)` is silently accepted instead of reporting "expected string literal".
