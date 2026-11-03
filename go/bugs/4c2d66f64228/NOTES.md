Reproducer: repro.sh compiles a package that dot-imports "testing" and only uses the name T as a struct literal key (S{T: 0}).
Clean toolchain: reports `"testing" imported and not used`, exit 1.
Buggy toolchain: the key is wrongly counted as a use of the dot import, so it compiles with no error, exit 0.
