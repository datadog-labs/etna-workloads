repro.go is upstream test/typeparam/issue49295.go. Read[T ~*[16]byte] calls len(t) on a pointer-to-array type parameter.
Clean: compiles and runs, exit 0, no output.
Buggy: the compiler fails with "invalid argument t (type go.shape.*uint8) for len". The injection collapses every pointer shape to *uint8, even for non-basic type args.
