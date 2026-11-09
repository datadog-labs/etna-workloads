Input: under strict mode, an `if` condition `(perf && perf.mark && perf.measure) ?? !!true` where `perf.mark`/`perf.measure` are always-defined methods.
Clean: reports TS2774 on both `perf.mark` (line 5) and `perf.measure` (line 6).
Injected: reports TS2774 only on `perf.mark`; the last operand `perf.measure` inside the parenthesized `??` operand is missed.
