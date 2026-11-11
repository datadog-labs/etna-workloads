# Adapted injection for Strip placeholders from hidden types before remapping generic parameter in the hidden type to the generic parameters of the definition of the opaque

Fix: https://github.com/rust-lang/rust/commit/6623bdf68b3d6e3984885ef72d62e7df0d256f7b

Fix hunk (compiler/rustc_borrowck/src/region_infer/opaque_types.rs, `@@ -192,6 +192,11 @@`): added
`ty::RePlaceholder(_) => ty::Region::new_error_with_message(..., "hidden type contains placeholders, we don't support higher kinded opaques yet")`
so placeholders never reach the generic-param remapping. That file/code no longer exists in 1.99.1; the logic is now in
compiler/rustc_borrowck/src/region_infer/opaque_types/mod.rs. Reintroducing the bug there (two hunks):

1. `ToArgRegionsFolder::try_fold_region`: regions of placeholder origin are passed through unchanged as `RePlaceholder`
   instead of being mapped/rejected (i.e. no longer stripped/replaced by an error region).
2. `collect_defining_uses`: after an invalid-args error (the "expected generic lifetime parameter, found 'any" error) in the
   non-next-solver path, no longer `continue`; the defining use is still collected, so the hidden type with placeholders is
   remapped by `remap_generic_params_to_declaration_params` (ReverseMapper hits `bug!("unexpected region kind")`), the original ICE.
