repro.sh builds a program using the method expression `reflect.Type.Method` (as in test/reflectmethod5.go)
and runs it, printing the first output line and exit status (the crash trace has addresses, so it is trimmed).

The injected bug makes walk skip marking the generated reflect.Type.Method wrapper as REFLECTMETHOD
(the check wrongly requires the result type's package not to be the local package), so the linker
prunes foo.X.
- clean: prints "called: true", status 0
- buggy: "fatal error: unreachable method called. linker bug?", status 2
