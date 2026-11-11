# Adapted injection for Don't call fn_arg_names for non-fn in resolver

Fix: https://github.com/rust-lang/rust/commit/29f31c58e9428ee6ad6c2faf2c391eea782f020d

# Rationale
File: compiler/rustc_resolve/src/late/diagnostics.rs, fn `lookup_assoc_candidate` ("Look for associated items in the current trait" block).
Re-expresses the fix hunk `@@ -2068,33 +2068,34 @@`: the fix restricted the `has_self` / `fn_arg_names` computation to `Res::Def(DefKind::Fn | DefKind::AssocFn, def_id)`. I reverted to the old behaviour: `let def_id = res.def_id();` and compute `has_self` (calling `tcx.fn_arg_idents`, the 1.99.1 name of fn_arg_names) for any res, including assoc types/consts, then match on res afterwards.
