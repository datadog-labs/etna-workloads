# Adapted injection for deduplicate the rest of AST walker functions

Fix: https://github.com/rust-lang/rust/commit/9b0ad97287c877c992ff15307adcb20c3583cbfb

# Re-injection
File: compiler/rustc_ast/src/ast.rs, structs `GenericParam` and `WherePredicate`: added `#[visitable(ignore)]` on the `id: NodeId` field of each.

Re-expresses the fix hunks that replaced the old hand-written walkers with macro-generated ones, e.g.
`-pub fn walk_generic_param<'a, V: Visitor<'a>>(... let GenericParam { id: _, ident, attrs, ...` (old immutable walker ignored `id`)
and `-    let WherePredicate { attrs, kind, id: _, span: _, is_placeholder: _ } = predicate;`
vs new `+ try_visit!(visit_id(vis, id));` in walk_generic_param / walk_where_predicate.
In 1.99.1 walkers are derived (`Walkable`), so ignoring the id field restores the old behaviour: the immutable visitor
never calls visit_id for generic params / where predicates, so buffered early lints (cfg check on `for<#[cfg(b)] c>`) are never emitted -> ICE at rustc_lint/src/early.rs:344 (issue 139825).
