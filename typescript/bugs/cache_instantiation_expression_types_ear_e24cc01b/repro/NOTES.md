input.ts uses `ReturnType<typeof createCacheReducer<QR>>` (an instantiation expression with an inapplicable type argument list) inside a recursive type alias.
Clean: tsc reports TS2344 and TS2635 and exits 2.
Injected: instantiation expression type is no longer cached, so error printing reenters and tsc crashes with "Maximum call stack size exceeded" (exit 1, no diagnostics on stdout).
