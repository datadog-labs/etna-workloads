repro.go is upstream test/typeparam/issue48047.go. A generic method calls an interface method on a field of generic interface type (`a.field.Work(t)`).
Clean: runs silently, exit 0.
Buggy: the compiler skips marking the interface method as used for shape-typed calls, so the linker deadcode-eliminates BImpl.Work. The program then crashes at runtime (exit status 2, with a goroutine dump).
