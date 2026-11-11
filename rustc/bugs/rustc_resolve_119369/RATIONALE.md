# Adapted injection for exclude unexported macro bindings from extern crate

Fix: https://github.com/rust-lang/rust/commit/9c3091e9cf9e7bb68afe3e06fd4e8c3986943285

# Rationale
File: compiler/rustc_resolve/src/build_reduced_graph.rs, `process_macro_use_imports` (glob `#[macro_use]` branch).
Re-expresses fix hunk `@@ -1048,11 +1048,25 @@` : the fix made the glob `#[macro_use]` only import macro bindings that are
accessible (`is_accessible_from(binding.vis, ..)`), with a `warn_private` compat import for the rest.
Reintroduced the old behaviour: every macro binding of the extern crate is imported with the plain import, regardless of
visibility (the accessibility check / private-compat branch removed), so unexported macros (e.g. `bar!`) leak in.
