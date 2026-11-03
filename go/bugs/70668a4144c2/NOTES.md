repro.go: declares an invalid cyclic generic type `type T[P any] struct{ T[P] }` and then calls
unsafe.Sizeof on T[int], struct{T[int]}, T[P], etc.
Clean toolchain: reports "invalid recursive type" and "not constant" errors.
Buggy toolchain: types2 hasVarSize recurses infinitely (no cycle check) -> fatal error: stack overflow in the compiler.
