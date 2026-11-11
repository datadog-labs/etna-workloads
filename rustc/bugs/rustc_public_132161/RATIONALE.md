# Adapted injection for [StableMIR] A few fixes to pretty printing

Fix: https://github.com/rust-lang/rust/commit/dd6ddcb18e56c4e3c29e49a4a98597927d2fad35

All changes in compiler/rustc_public/src/mir/pretty.rs (file moved from compiler/stable_mir).
- pretty_rvalue, Rvalue::Repeat: restored `"{} \" \" {}"` instead of `[{}; {}]` (fix hunk `@@ -360,22 +359,74 @@` Repeat).
- pretty_rvalue, Rvalue::UnaryOp: restored `"{} \" \" {:?}"` (operand then op) instead of `{:?}({})` (same hunk).
- pretty_statement: removed `{INDENT}` from FakeRead, StorageLive, StorageDead (fix hunk `@@ -73,39 +75,40 @@`, which added INDENT to these).
