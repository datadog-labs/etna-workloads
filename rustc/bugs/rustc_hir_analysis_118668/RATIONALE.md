# Adapted injection for Resolve assoc item bindings by namespace

Fix: https://github.com/rust-lang/rust/commit/55559d93e74d5cf48a041803597201640046b5bd

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/bounds.rs, fn lower_assoc_item_constraint (1.99.1 successor of astconv/bounds.rs `add_predicates_for_ast_type_binding`).

The fix hunk (`@@` in astconv/bounds.rs introducing `let assoc_kind = if RTN {Fn} else if Equality(term) && Const(_) {Const} else {Type}` and replacing `find_item_of_kind(Type).or_else(find_item_of_kind(Const))` with a single `.find(|i| i.kind == assoc_kind)`) is reverted:
1. Removed the `Const` branch of `assoc_tag`: non-RTN constraints always resolve as Type (the old "resolve a type first" behaviour).
2. Candidate trait search: Type, with fallback to Const (old `trait_defines_associated_item_named(Type)` path plus const fallthrough).
3. Item lookup: `probe_assoc_item(Type).or_else(Const)`, mirroring the removed `find_item_of_kind(Type).or_else(find_item_of_kind(Const))`.
Result: when a type and const share a name, a const binding resolves to the type (the bug in issue 112560).
