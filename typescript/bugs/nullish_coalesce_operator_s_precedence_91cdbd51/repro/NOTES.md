Input mixes `a ?? b || c` without parentheses (a syntax error per spec).
Clean tsc reports TS5076 ("'??' and '||' operations cannot be mixed without parentheses") and emits `(a !== null && a !== void 0 ? a : b) || c`.
Injected tsc reports no error (Coalesce precedence is wrong, so `??` is parsed as binding looser than `||`) and emits `a !== null && a !== void 0 ? a : b || c`.
