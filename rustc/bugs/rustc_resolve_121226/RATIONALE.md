# Adapted injection for Fix issues in suggesting importing extern crate paths

Fix: https://github.com/rust-lang/rust/commit/3bcef2dc1b145ebe32d317e331579fd4c20e0bd8

# Rationale
File: compiler/rustc_resolve/src/diagnostics/impls.rs (module `lookup_import_candidates_from_module`, formerly diagnostics.rs).
Removed the `alias_import` computation (`DeclKind::Import` + `ImportKind::ExternCrate { source: Some(_) }` + same expansion) and reverted the condition to `if !is_extern_crate_that_also_appears_in_prelude {`.
Re-expresses fix hunk `@@ -1290,10 +1290,20 @@` which added `alias_import` and changed the condition to `if !is_extern_crate_that_also_appears_in_prelude || alias_import {`.
