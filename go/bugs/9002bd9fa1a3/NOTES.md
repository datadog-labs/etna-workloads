repro.go is the issue78410 test program (clear of a []byte literal whose element is indexed from a string([]byte{'x'}[:]) conversion) plus a main.
Clean toolchain compiles and prints "ok"; the buggy toolchain hits an internal compiler error ("value .autotmp_N incorrectly live at entry") and exits 1.
