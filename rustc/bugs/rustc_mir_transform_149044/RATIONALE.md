# Adapted injection for Reduce confusing `unreachable_code` lints

Fix: https://github.com/rust-lang/rust/commit/98141e0beb94c3c96a225614a2e63b08c2dba5ac

The fix's code was in mir_build/builder/mod.rs; in 1.99.1 it moved to compiler/rustc_mir_transform/src/lint_and_remove_uninhabited.rs, function `find_unreachable_code_from`.

Fix hunk `@@ -861,20 +861,46 @@` added `find_unreachable_code_from`. It skips the implicit unit `()` assign (`if const_.ty().is_unit() => continue`). It returns None for `Goto`/`Return` terminators (`TerminatorKind::Goto { .. } | TerminatorKind::Return => None`). Its caller skips the lint when the result is None (`else { continue; }`).

Re-injected the old behaviour in two edits:
1. Removed the unit-constant assignment skip arm. The lint now fires on the implicit `()` assignment.
2. Replaced the terminator match with an unconditional `Some((term.source_info, "expression"))`. Goto, Drop and Return now get linted.
