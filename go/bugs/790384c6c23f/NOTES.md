`repro.go` declares `type A[P any] = P`, an alias whose RHS is a type parameter declared in the same alias declaration. The spec forbids this.

- go-clean rejects it. It exits 1 with "cannot use type parameter declared in alias declaration as RHS".
- go-buggy has lost that check in types2, so it compiles the program and exits 0.
