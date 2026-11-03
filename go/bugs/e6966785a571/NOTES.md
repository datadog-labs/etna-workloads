repro.go is the upstream test for issue 80976. It calls a generic method `Set` with a type argument (`res`) that contains `HashSet[int]`.

The type argument's name ends in the method name followed by a bracket.

- go-clean: builds and runs with exit status 0.
- go-buggy: the link fails with `relocation target main.(*TypeMap).Set[int] }] not defined`, exit status 1. The noder uses `strings.LastIndex` to find the method name and builds a bogus method target.
