# Adapted injection for get rid of an old hack

Fix: https://github.com/rust-lang/rust/commit/20d241492590a83eb0946ce4414255e25d2112b8

# Rationale
File compiler/rustc_abi/src/layout.rs, `LayoutCalculator::univariant_biased` (field loop).
Re-expresses the fix hunk `@@ -1148,7 +1148,11 @@ impl<Cx: HasDataLayout> LayoutCalculator<Cx>`:
the `if let StructKind::MaybeUnsized = kind { unsized_field = Some(field) } else { return Err(UnexpectedUnsized) }`
is reverted to unconditional `unsized_field = Some(field);`, so always-sized structs get an unsized layout
(hitting the retained `bug!("got unsized layout for type that cannot be unsized")` ICE in rustc_ty_utils).
The ty_utils hunks (removing err_if_unsized hack) were not reinjected; the hack's removal wasn't needed to reproduce the ICE.
