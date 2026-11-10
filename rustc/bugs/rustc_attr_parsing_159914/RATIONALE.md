# Adapted injection for fix: error in diagnostic on_unmatched_args

Fix: https://github.com/rust-lang/rust/commit/029a24092d56094a69bf7c0842933adadb4001fc

# Rationale
File: compiler/rustc_attr_parsing/src/attributes/diagnostic/on_unmatched_args.rs, OnUnmatchedArgsParser accept closure.

Fix hunk `@@ -17,6 +17,8 @@ impl AttributeParser for OnUnmatchedArgsParser` added `args.ignore_args();` before `return;` in the `if !cx.features().diagnostic_on_unmatched_args()` branch.
In 1.99.1 that code was restructured: the gate is the `gate_diagnostic_attr!` macro (which calls `args.ignore_args()` and emits a lint, and the lint also bypasses the unused-args debug check). I replaced the macro call with the pre-fix form: `if !cx.features().diagnostic_on_unmatched_args() { return; }` with no `ignore_args()`. With the feature disabled, the args are never marked used, so the debug-assertions arguments-used check fires.
