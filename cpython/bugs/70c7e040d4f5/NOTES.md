Reproducer: an optional `--foo` with `nargs=REMAINDER` followed by a positional `bar nargs='*'`.
Clean: `--foo` consumes everything after it, including `--` (e.g. `foo=['--', 'a', 'b']`).
Buggy: the pattern is `[AO]*`, so it stops at the first `--`; the result differs (or errors).
