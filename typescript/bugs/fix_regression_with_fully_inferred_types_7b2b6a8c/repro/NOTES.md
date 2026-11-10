input.ts declares `let last;` (auto-typed) assigned inside a loop with an early return, then reads `last` and `last!` after the loop (same with an array variant), under --noImplicitAny.
Clean build: no errors (exit 0), since `last!` is fully inferred.
Injected build: reports TS7034 on the declarations and TS7005 "implicitly has an 'any' type" at `last!` / `result!`, so output and exit status differ.
