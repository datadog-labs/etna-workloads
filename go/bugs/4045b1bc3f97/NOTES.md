repro.go is upstream test/typeparam/issue53406.go. A generic function f[T1] calls the promoted method M of an embedded Inner[int] through Outer[T1,int].
Clean: compiles and runs, exit 0. Buggy: internal compiler error "assertion failed" (the injected assert in noder/writer.go), exit 1.
