# Adapted injection for remove is global hack

Fix: https://github.com/rust-lang/rust/commit/e30d27be00c5fd3dda58cbb04013974f978710da

# Rationale

One hunk: `compiler/rustc_middle/src/ty/mod.rs`, `ParamEnv::and`.

Re-expresses the fix hunk `@@ -1752,30 +1752,9 @@ impl<'tcx> ParamEnv<'tcx>`, which replaced the body of `and` with
`ParamEnvAnd { param_env: self, value }` and removed the "is global" hack
(`if value.is_global() { ParamEnvAnd { param_env: self.without_caller_bounds(), value } }`).

In 1.99.1 `ParamEnv` no longer carries `Reveal` (the typing mode lives in the InferCtxt), so the
original `Reveal::All` condition cannot be expressed here. The hack is restored for every global value:
the caller bounds are dropped (`ParamEnv::empty()`). `canonicalize_query` calls `param_env.and(value)`,
so canonical queries lose the `for<'a> (): Bar<'a>` where-clause. That makes impl-is-shadowed.rs ICE in `fully_perform`.
