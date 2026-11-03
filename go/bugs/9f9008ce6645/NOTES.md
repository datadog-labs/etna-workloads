`repro.sh` declares `type A[P any] [1]P; type B[P any] A[P]; type C B[C]` (the issue 65711 pattern).

- go-clean: reports `invalid recursive type C` with the cycle `C -> B[C] -> A[P] -> C`.
- go-buggy: the compiler hits `fatal error: stack overflow`.

The bug is the re-enabled `check.valids` early exit in types2 `validType`. The uninstantiated `A` is cached as valid, so the cycle that runs through `A[P]` is never detected. Type checking then recurses without end.

The compiler prints a goroutine dump with addresses when it crashes. The script filters its output down to the stable diagnostic lines and the `fatal error` line.
