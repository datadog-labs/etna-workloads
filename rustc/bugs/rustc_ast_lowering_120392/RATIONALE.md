# Adapted injection for Error on incorrect item kind in async bound

Fix: https://github.com/rust-lang/rust/commit/3913c9a0cacf4bacb4ca1c6255271d54ec995f02

# Rationale
File: compiler/rustc_ast_lowering/src/path.rs, fn lower_qpath (async bound handling).
Re-expresses fix hunk `@@ -42,15 +44,24 @@` in path.rs: the fix replaced
`if let Res::Def(DefKind::Trait, def_id) = res { ... else { panic!(); } } else { panic!(); }`
with a `match` emitting AsyncBoundOnlyForFnTraits / AsyncBoundNotOnTrait / no error for Res::Err.
I restored the two `panic!()`s (non-Fn trait, and non-trait/Res::Err). The error structs remain defined (now unused import warning); the ftl/errors hunks are only supporting definitions.
