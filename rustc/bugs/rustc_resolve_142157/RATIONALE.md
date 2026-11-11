# Adapted injection for rustc_resolve: Improve `resolve_const_param_in_non_trivial_anon_const` wording

Fix: https://github.com/rust-lang/rust/commit/4882ea4b3c47749743df90718cdafa5637706b9d

# Rationale
compiler/rustc_resolve/src/diagnostics/mod.rs (ParamInNonTrivialAnonConst `#[help(...)]`, line ~423): the message moved from messages.ftl to an inline attribute in 1.99.1. Reverted wording "arguments here, i.e." -> "arguments, i.e.", re-expressing fix hunk in compiler/rustc_resolve/messages.ftl:
-    const parameters may only be used as standalone arguments, i.e. `{$name}`
+    const parameters may only be used as standalone arguments here, i.e. `{$name}`
