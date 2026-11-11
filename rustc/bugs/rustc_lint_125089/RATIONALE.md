# Adapted injection for non_local_defs: be more precise about what needs to be moved

Fix: https://github.com/rust-lang/rust/commit/d3dfe14b53e2211138e3a4eae5915351ff62f5bc

# Rationale
File compiler/rustc_lint/src/non_local_def.rs, `NonLocalDefinitions::check_item` (ItemKind::Impl).
The fix's lints.rs/non_local_def.rs hunks (`@@ pub enum NonLocalDefinitionsDiag` `-self_ty: Span, -of_trait: Option<Span>` `+may_move: Vec<Span>`, and
`@@ ... impl LateLintPass for NonLocalDefinitions` computing `may_move` only from paths where `path_has_local_parent`)
made the "may need to be moved" labels precise. 1.99.1 rewrote this to per-path "`X` is not local" labels built from the filtered `collector.paths`.
Re-expression: snapshot `all_paths` before the `collector.paths.retain(...)` filter (which drops type params / non-Def paths) and label
every collected path from `all_paths`, i.e. imprecise labelling of things that don't need moving (e.g. type params `T`), as the pre-fix code labelled self_ty/trait unconditionally.
The bail-out check still uses the filtered paths.
