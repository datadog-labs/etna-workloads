# Adapted injection for Don't consider RibKind::Module's bindings when checking generics shadowing

Fix: https://github.com/rust-lang/rust/commit/78d0e08504a30e5ff8b8e0ba88126af95a16a398

# Rationale
File: compiler/rustc_resolve/src/late.rs, fn with_generic_param_rib.
Fix hunk `@@ -2677,14 +2677,14 @@` moved `seen_bindings.extend(parent_rib.bindings...)` after the `RibKind::Module` break check. In 1.99.1 the check is `Module | Block`; I moved the extend back before the break, so the Module/Block rib's own bindings are again counted as shadowed (old behaviour).
