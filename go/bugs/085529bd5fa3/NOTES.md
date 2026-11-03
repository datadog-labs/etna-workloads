repro.go calls unsafe.Offsetof(d.B) and unsafe.Offsetof(d.Embedded) inside a generic function, where B is promoted from an embedded struct, and prints both offsets.
Clean toolchain: both offsets are equal (8 8). Buggy toolchain: Offsetof(d.B) is computed against the wrong base selector, so the two offsets differ.
