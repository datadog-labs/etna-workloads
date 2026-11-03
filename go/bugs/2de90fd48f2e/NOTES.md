repro.go is the upstream test issue78262.go: a struct literal with keyed fields promoted through nested embedded structs (A{a:1, b:2, c:3}).
Clean toolchain compiles and runs it (exit 0, no output). Buggy toolchain fails with "internal compiler error: want STRUCT, but have int" because the reader modifies the original typ while walking embedded fields.
