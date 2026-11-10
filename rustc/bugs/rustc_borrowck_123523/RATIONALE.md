# Adapted injection for Account for trait/impl difference when suggesting changing argument from ref to mut ref

Fix: https://github.com/rust-lang/rust/commit/731c0e59a4a3c7f05adad86bd7793af1d8e6c51a

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/mutability_errors.rs, fn `is_error_in_trait`.
Re-expresses fix hunk `@@ -695,19 +702,16 @@`: the fix replaced an unconditional `Some(span)` for the trait fn's argument with
`if let ... && let hir::TyKind::Ref(_, mut_ty) = ty.kind && let hir::Mutability::Not = mut_ty.mutbl && sig.decl.implicit_self.has_implicit_self() { Some(ty.span) } else { None }`.
I removed the Ref/Not and has_implicit_self guards, so a trait-side arg that is not an `&self` (e.g. anonymous param `Self::Assoc<'_>`) is used as the additional suggestion span, giving a wrong suggestion/ICE-like behaviour.
