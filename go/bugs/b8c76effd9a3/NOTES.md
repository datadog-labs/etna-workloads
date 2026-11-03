repro.sh builds a two-package module equivalent to test/fixedbugs/issue65957.dir.

- Package a converts `new([4]int32)` to an interface.
- main has `var s = []rune{0,1,2,3}`, whose static init creates a noalg `[4]int32` backing array.
- main then uses `reflect.ArrayOf(4, int32)` as a map key.

With the bug, the pointer to the noalg array type is not marked noalg. `*[4]int32` lands in typelinks with a ptrToThis that points at the noalg `[4]int32`, so reflect.ArrayOf returns that type.
go-buggy panics with "hash of unhashable type [4]int32" at the map insert. go-clean prints "ok 4".
