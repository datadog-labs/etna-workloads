repro.go is test/fixedbugs/issue53309.go. A generic function does a type assertion `v.(*taskResult)` on a value whose type is an interface instantiated with a type parameter.

Clean toolchain: the assertion succeeds and the program exits 0 with no output.
Buggy toolchain: the assertion wrongly fails, so the program panics with "output must be *taskResult" and exits with status 2.
