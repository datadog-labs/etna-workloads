# Adapted injection for Check importing crate/$crate/super after handling self

Fix: https://github.com/rust-lang/rust/commit/5cfaadaa5083712f0f4c1debcc83d2ac1c2a8ad1

# Rationale
File: compiler/rustc_resolve/src/build_reduced_graph.rs, fn build_reduced_graph_for_use_tree, `UseTreeKind::Simple` arm.

Fix hunk: `@@ -629,6 +629,35 @@` moved the `kw::SelfLower` handling (`module_path.pop()`, `source = parent`) in front of the
`match source.ident.name { kw::DollarCrate / kw::Crate / kw::Super ...}` so that the parent (crate/$crate/super) of
`prefix::{self}` is validated by those arms. The second hunk (`@@ -664,45 +693,14 @@`) removed the old `kw::SelfLower` arm
that ran *inside* the match, after which the popped parent was never checked.

1.99.1 no longer pops the parent for `self` (self handled later in imports.rs), so the hunks don't reverse literally.
I re-created the buggy ordering: `source` is now `mut`, and when source is `self` with a parent of super/crate/$crate,
the parent is popped into `source` *before* the match... Note the match then sees source=parent with a shortened path,
so for `crate::x::super::{self as c}` the `super` arm fires with its old message and later resolution gives
"cannot find `crate1` in `x`", i.e. the parent-is-not-validated-as-path-segment behaviour differs from the fixed output,
making use-super-in-middle.rs fail.
