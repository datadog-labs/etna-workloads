# Adapted injection for Detect unconstructable re-exported tuple structs

Fix: https://github.com/rust-lang/rust/commit/8f7d61b9efe1f44701f87fe4647eb1f39d20f434

# Rationale
One hunk: compiler/rustc_resolve/src/late/diagnostics.rs, `smart_resolve_context_dependent_help` (the `(Res::Def(DefKind::Struct, def_id), source) if ns == ValueNS` arm).
In 1.99.1 the fix's logic was rewritten (no `inaccessible_ctor_reexport` map; it re-resolves the module path and checks `ctor.has_private_fields(import_mod)`). I removed the whole block that adds the "the type is accessed through this re-export..." span_note, the "the type can be constructed directly" suggestion, and the extra `update_err_for_private_tuple_struct_fields` call. This re-expresses the fix hunk
`@@ -1942,44 +1942,77 @@ ... LateResolutionVisitor` (`if let Some(use_span) = self.r.inaccessible_ctor_reexport.get(&span) && is_accessible { err.span_note(...); err.span_suggestion_verbose(...); update_message(...) }`), i.e. parent behaviour with no re-export diagnostic extension. The ident.rs/lib.rs hunks (tracking map) have no counterpart in 1.99.1 since the logic is computed on demand.
