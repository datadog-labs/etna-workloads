# Adapted injection for Do not suggest unresolvable builder methods

Fix: https://github.com/rust-lang/rust/commit/273a78b05be72a4609d68740708d27fdeacd29f6

# Rationale
File: compiler/rustc_hir_typeck/src/method/suggest.rs, fn `find_builder_fn`.
Re-expresses the last hunk of fix.diff (`@@ -1953,8 +1956,23 @@ ... fn find_builder_fn`): the fix added a `.filter` that
requires `self.probe_for_name(Mode::Path, item.ident(..), None, IsSuggestion(true), rcvr_ty, expr_id, ProbeScope::TraitsInScope).is_ok()`
(only resolvable builders). I restored the old filter `matches!(item.kind, Fn{has_self:false,..})` only, so unresolvable
(private / unsatisfied-bounds) functions are suggested again. The expr_id plumbing hunks are kept (param renamed `_expr_id` to avoid unused warning); they are inert.
