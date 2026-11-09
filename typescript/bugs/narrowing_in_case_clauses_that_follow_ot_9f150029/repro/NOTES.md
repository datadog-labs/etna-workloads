input.ts: a `switch (true)` after an `if (!arg) throw` guard, where a case clause follows a returning clause and an empty case falls through to another.
Clean: no diagnostics. Injected: the binder loses the narrowing flow for the clause after the return, so `arg` is `string | undefined` and tsc reports "'arg' is possibly 'undefined'" (strict).
