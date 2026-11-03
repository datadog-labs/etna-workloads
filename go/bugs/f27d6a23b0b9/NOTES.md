repro.sh builds a module with package `a` (generic funcs using unsafe.Sizeof/Alignof on a type parameter) and a main that calls them.
Clean: prints "8 1", exit 0.
Buggy: the injected writer.go change writes package unsafe as "builtin", so unsafe builtins are mis-resolved on import; the compiler hits internal compiler errors (e.g. in internal/abi, internal/stringslite) and the build fails.
