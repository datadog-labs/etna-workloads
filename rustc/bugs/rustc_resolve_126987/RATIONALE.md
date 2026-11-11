# Adapted injection for out_of_scope_macro_calls: Detect calls inside attributes more precisely

Fix: https://github.com/rust-lang/rust/commit/83cf471361ed8e5d07111312a80b29b6ecb3290b

# Rationale
File compiler/rustc_resolve/src/macros.rs, fn resolve_macro_invocation (`looks_like_invoc_in_mod_inert_attr`).
Re-expresses the fix hunk `@@ -297,11 +297,12 @@ impl ResolverExpand for Resolver`, which added `in_attr && invoc.fragment_kind == Expr ...` to the filter.
I removed the `in_attr` condition (and the unused binding), so any Expr invocation whose parent is a module
is treated as being in an inert attribute -> false-positive out_of_scope_macro_calls for `global_asm!(mac!())` / `include!(mac2!())`.
The in_attr tracking in def_collector/lib.rs (other hunks) is left in place (it is now just unused by this check).
