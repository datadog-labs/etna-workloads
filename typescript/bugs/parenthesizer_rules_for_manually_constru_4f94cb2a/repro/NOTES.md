Input mixes `??` with `||`/`&&` without parentheses (a syntax error TS5076, but emit still happens) and uses `!` non-null assertions on an operand.
Stripping `!` makes the transformer rebuild the binary expression, which re-runs the parenthesizer rules.
Clean build emits `(a || b) ?? c`, `a ?? (b && c)` etc.; the injected build emits the mixed operators without parentheses (`a || b ?? c`).
