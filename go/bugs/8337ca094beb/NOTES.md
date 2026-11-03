repro.go passes the generic function `g` twice to `f(func(int), func(string))`.
Clean go1.27.3 renames the type parameters per argument, so both are inferred and it compiles and runs (exit 0).
The buggy toolchain doesn't rename them, so it fails with
`in call to f, type func[P any](x P) of g does not match func(string)` (exit 1).
