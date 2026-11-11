# Adapted injection for Ensure define_opaque is accounted for in HIR hash

Fix: https://github.com/rust-lang/rust/commit/4b22ac5296a7a40aebfc997eec122fbfe50164da

# Rationale
File: compiler/rustc_middle/src/hir/mod.rs, fn `TyCtxt::hash_owner_nodes`.
Removed the `define_opaque.stable_hash(&mut hcx, &mut stable_hasher);` call (and its comment) so the attrs hash no longer includes the defined opaque types. This re-expresses fix hunk `@@ -168,6 +169,10 @@ impl<'tcx> TyCtxt<'tcx>` ("Hash the defined opaque types, which are not present in the attrs."). The parameter is kept (renamed `_define_opaque`), so the callers (hunks in ast_lowering/lib.rs and ty/context.rs, which the fix changed to pass it) still compile.
