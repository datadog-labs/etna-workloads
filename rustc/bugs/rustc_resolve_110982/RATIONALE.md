# Adapted injection for Do not recurse into const generic args when resolving self lifetime elision.

Fix: https://github.com/rust-lang/rust/commit/8972a23f4827e784a9dc2f14435d2bc34197c74b

# Rationale
File compiler/rustc_resolve/src/late.rs, fn `find_lifetime_for_self`, `impl Visitor for FindReferenceVisitor`.
Removed the override `fn visit_expr(&mut self, _: &'ra Expr) {}` (and its comment) that the fix added
(fix hunk `@@ -2075,6 +2075,10 @@ impl<'a: 'ast, 'b, 'ast, 'tcx> LateResolutionVisitor`, adding
"// A type may have an expression as a const generic argument. // We do not want to recurse into those.").
Without it the visitor walks into const-generic expressions (nested fn items), finding the nested `&self` lifetime -> ICE (bug #110899).
