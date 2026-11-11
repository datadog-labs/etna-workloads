# Adapted injection for Make a fake body to store typeck results for global_asm

Fix: https://github.com/rust-lang/rust/commit/6ba39f7dc709a90bcb125974964a7e464ed86ff2

# Rationale
Only hunk changed: compiler/rustc_hir/src/intravisit.rs, `walk_item`, `ItemKind::GlobalAsm` arm.
Re-expresses fix.diff hunk `@@ -573,9 +573,13 @@ pub fn walk_item` which replaced
`ItemKind::GlobalAsm { asm } => { visit_id; visit_inline_asm(asm, item.hir_id()) }` with
`ItemKind::GlobalAsm { asm: _, fake_body } => { ... visit_nested_body(fake_body) }`
(comment: don't visit the asm outside the body or visitors lack typeck results).
Reintroduced the old behaviour: the asm is walked directly from the item (outside the fake body), so
visitors (typeck-results users, closures/lifetimes in sym operands) run without typeck results set.
The rest of the fix (fake body plumbing) is already present in 1.99.1 and left intact.
