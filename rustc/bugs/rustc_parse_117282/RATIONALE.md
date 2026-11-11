# Adapted injection for Recover from incorrectly ordered/duplicated function keywords

Fix: https://github.com/rust-lang/rust/commit/be0b42fabe4b4abe10e7b6eb5e57ea12b6fa07c9

# Rationale
File: compiler/rustc_parse/src/parser/function.rs, fn `parse_fn_front_matter` (moved from item.rs in 1.99.1).

Removed the block (after `// FIXME(gen_blocks)...`) that, when `wrong_kw.is_some() && self.may_recover() && look_ahead(1, fn)`,
bumps the misplaced keyword and `fn`, emits the error and returns `Ok(FnHeader{recover_*...})`. Now it always falls to `return Err(err)`.
Re-expresses fix hunk `@@ -2467,6 +2484,23 @@` (the added `if wrong_kw.is_some() && self.may_recover() && ... return Ok(FnHeader { constness: recover_constness, ...})`).
The `recover_*` variables (fix hunk `@@ -2382,22 +2382,39 @@`) are left in place but are now unused (warnings only).
