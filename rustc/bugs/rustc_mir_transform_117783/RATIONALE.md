# Adapted injection for Fix insertion of statements to be executed along return edge in inlining

Fix: https://github.com/rust-lang/rust/commit/1be1c2ebcfd0ab10cbf001cc5d2471686a98aded

# Rationale
File: compiler/rustc_mir_transform/src/inline.rs, fn `inline_call`.
In 1.99.1 the code creates a dedicated block (`BasicBlockData::new(Goto{target: block})`, pushed to the caller) as `return_block`. I replaced it with `let return_block = target;`, so the destination assignment / StorageDead statements are again inserted directly into the call's target block (which may have other predecessors). This re-expresses the fix hunks that introduced `return_block` as a fresh block instead of using `target` directly (the `@@ -367` / `-386` hunks in inline.rs: "Prepare a new block for code that should execute when call returns").
