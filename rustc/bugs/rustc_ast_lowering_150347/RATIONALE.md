# Adapted injection for Recursive delegation improvements

Fix: https://github.com/rust-lang/rust/commit/3f477dd71082c6342ae34d32b49a63735ce0bc6f

# Re-injection of the bug fixed by 3f477dd7 (PR #150347, issue #150152)

In 1.99.1, delegation lowering has been rewritten: it's now split into `rustc_ast_lowering/src/delegation/{mod,resolution,generics,attributes}.rs`, and `delegation_infos` holds a `resolution_id: Result<DefId, _>`.
So the fix's hunks don't apply as-is. I re-expressed its two behavioural changes; the attribute-inheritance refactor is left out because the old file layout no longer exists.

## Hunk 1: compiler/rustc_ast_lowering/src/delegation/resolution.rs, `DelegationResolver::resolve_delegation` / `check_for_cycles`
- What it does: `check_for_cycles` already walks the chain of delegations (reuse -> reuse -> ... -> fn). Now it returns the
  last `DefId` in that chain (the root function), and `resolve_delegation` uses that as `sig_id` instead of the immediate
  delegee. This brings back the parent-commit behaviour of `get_delegation_sig_id`, which looped until it hit a
  non-delegation and returned `Ok(def_id)` (the root). The decl, the sig and the generics were all derived from that root.
- Fix hunks it reverts:
  - `@@ -124,19 +152,36 @@ impl<'hir> LoweringContext<'_, 'hir> {`. The fix replaced
    `let decl = self.lower_delegation_decl(sig_id, ...)` with
    `let decl = self.lower_delegation_decl(delegee_id, param_count, c_variadic, span);`, with the comment
    "Here we use `delegee_id`, as this id will then be used to calculate parent for generics inheritance, and we want
    this id to point on a delegee, not on the original function (see #150152 comment)".
  - `@@ -262,14 +323,15 @@` / `@@ -279,7 +341,7 @@`. The fix changed `-                return Ok(def_id);` into
    `+                return Ok(DelegationIds::new(path));`, where `delegee_id()` is `path.first()` and
    `root_function_id()` is `path.last()`.
- Effect: when a delegation reuses another delegation, parent generics are computed from the root function's parent instead of
  the delegee's parent. That causes an ICE in `generics.rs:392` ("range start index 1 out of range for slice of length 0").

## Hunk 2: compiler/rustc_resolve/src/late.rs, `LateResolutionVisitor::resolve_impl_item` (Delegation arm)
- What it does: brings back `this.resolve_delegation(delegation, item.id, trait_id.is_some())` in place of `is_in_trait_impl`.
  With this, a delegation inside an impl of an *unresolved* trait is treated as if it were not in a trait impl.
- Fix hunk it reverts: `@@ -3550,7 +3552,9 @@`:
  `-                        this.resolve_delegation(delegation, item.id, trait_id.is_some());`
  `+                        // Here we don't use `trait_id`, as we can process unresolved trait, however ... #150152`
  `+                        this.resolve_delegation(delegation, item.id, is_in_trait_impl, &item.attrs);`
  (1.99.1 already passes `is_in_trait_impl` into `resolve_impl_item`, so I only changed the call.)
- Effect in 1.99.1: none that the oracle tests observe. `recursive-delegation-ice-150152.rs` still produces the expected
  diagnostics, because the later code tolerates the resolution. I kept the hunk because it is a faithful part of the parent behaviour.
