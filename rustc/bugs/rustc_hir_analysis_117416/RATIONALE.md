# Adapted injection for Also consider TAIT to be uncomputable if the MIR body is tainted

Fix: https://github.com/rust-lang/rust/commit/48491c182be06aad6db5edfd60bdcab0917cb79d

# Rationale
File: compiler/rustc_hir_analysis/src/collect/type_of/opaque.rs, `TaitConstraintLocator::check`, `DefiningScopeKind::MirBorrowck` arm.
Fix hunk `@@ -183,9 +183,17 @@ impl TaitConstraintLocator<'_>`: added "If the body was tainted ... set it to error" (`borrowck_results.tainted_by_errors` -> found = error type).
In 1.99.1 a tainted MIR body is `mir_borrowck` returning `Err(guar)`; the arm inserted an error hidden type. Reintroduced bug: `Err(_) => {}`, so a tainted body is ignored and the TAIT is reported as unconstrained.
