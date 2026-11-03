repro.go converts an `any` value to a defined interface type `anyWrapper` (an OCONVNOP) and then calls a method via a type assertion. The devirtualizer walks through the conversion.

- go-clean: compiles and prints `Impl.M`.
- go-buggy: internal compiler error "not identical/interface types found n1.Type = anyWrapper; n1.X.Type = any" (exit 1). The buggy code compares the types with `Identical` instead of comparing their underlying types.
