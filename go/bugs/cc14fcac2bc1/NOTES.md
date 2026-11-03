repro.go declares `type T[U interface{ M() T[U] }] int`, a cycle through a type parameter list (from test/typeparam/issue46461.go).
Clean go1.27.3 compiles and runs it (prints 1). The buggy toolchain rejects it with "invalid recursive type: T refers to itself" because the type-parameter-cycle exemption in types2 validType/cycle check was removed.
