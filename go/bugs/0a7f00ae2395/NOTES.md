repro.sh builds a two-package module. Package a has a 30-entry map literal, so the compiler creates a
[30]int key/value array. Package b compares reflect.TypeOf([30]int{}) with the Elem of *[30]int.

Clean: prints "ok". Buggy: the array type is wrongly marked noalg, so the two types compare unequal
and the program panics with "[30]int types do not match" (exit status 2).
