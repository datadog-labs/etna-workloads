# Adapted injection for Reject relaxed bounds inside trait alias bounds

Fix: https://github.com/rust-lang/rust/commit/ce68cd3762fef8eb799b5b75ba07eb82597de44f

# Rationale
Hunk: compiler/rustc_ast_lowering/src/item.rs, `lower_item_kind` (ItemKind::TraitAlias arm).
Re-expresses fix hunk `@@ -426,7 +426,7 @@` which changed `RelaxedBoundPolicy::Allowed` to
`RelaxedBoundPolicy::Forbidden(RelaxedBoundForbiddenReason::TraitAlias)`. We restore `Allowed(&mut Default::default())`
(Allowed now carries a dedup map in 1.99.1), so `?Sized` in trait alias bounds is accepted again.
The enum variant TraitAlias and its diagnostic arm in lib.rs are left in place (harmless, now unused path).
