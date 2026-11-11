# Adapted injection for Do not request sanitizers for naked functions

Fix: https://github.com/rust-lang/rust/commit/54ebb9d4897c2f372e3b20f833c2ea4eaf656a0e

# Rationale
File: compiler/rustc_codegen_llvm/src/attributes.rs, fn llfn_attrs_from_instance.
Fix hunk `@@ -411,26 +411,31 @@` moved `to_add.extend(sanitize_attrs(...))` into the `else` (non-NAKED) branch with comment "Do not set sanitizer attributes for naked functions."
Reintroduced bug: sanitize_attrs is called unconditionally, before the `if NAKED {..} else {..}`, so naked functions get sanitizer attributes again.
