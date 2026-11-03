Reproducer: repro.go is upstream test/typeparam/issue50642.go.
It does generic comma-ok receive and map lookup (OAS2RECV/OAS2MAPR) assigning T to an interface-typed var.
Clean: compiles and runs OK (exit 0). Buggy: internal compiler error "incomplete itab" at compile time (exit 1).
