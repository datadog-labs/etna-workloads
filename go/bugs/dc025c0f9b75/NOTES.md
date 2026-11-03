repro.sh compiles a file returning `[...]int{2: 0}` as `[2]int`, which is a type error.
Clean toolchain prints `cannot use [...]int{…} (value of type [3]int) ...`.
Buggy toolchain drops the `...` (ODDD not formatted) and prints `[]int{…}`.
