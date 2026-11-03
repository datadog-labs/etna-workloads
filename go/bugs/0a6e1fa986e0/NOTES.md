Reproducer: repro.go is the upstream test for issue 54537 (generic code with `var _ T = x == "foo"`, T ~bool, plus a call to G(x == "foo")).
Clean toolchain: compiles and runs with no output, exit 0.
Buggy toolchain: typecheck.Conv/ConvNop use types.Identical instead of IdenticalStrict, so an "untyped bool" is left unconverted in walk. The compiler hits an internal compiler error ("expression has untyped type") and exits nonzero.
