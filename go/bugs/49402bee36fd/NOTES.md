repro.sh reproduces test/fixedbugs/issue47185 as a small module (cgo package `bad` + main, both using large zero-valued map elements, with external linking).
Clean toolchain: builds and runs, prints "ok". Buggy toolchain: the build fails with
"go:map.zero: is content-addressable but alignment is not set (size is 4096)" because map.zero is marked content-addressable instead of static.
