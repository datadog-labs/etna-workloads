repro.sh builds a small module (packages a, b, p, main) mirroring test/fixedbugs/issue52128.
p calls a.NewWithFuncI((&b.S{}).M1). Inlining the method-value wrapper for M1 reveals a new
method value `s.M2` (from b.M1), which needs its own wrapper.

- go-clean: builds and runs, exit 0.
- go-buggy: `internal compiler error: missing wrapper for M2` while compiling m/p (exit 1),
  because finishWrapperFunc no longer generates wrappers for method values revealed by inlining.
