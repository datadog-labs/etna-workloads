repro.go is test/fixedbugs/issue59190.go made into a main program. It uses unsafe.Sizeof/Offsetof on oversize types.
Clean go reports "... is too large" at the unsafe.Sizeof/Offsetof calls. The buggy toolchain skips that check and instead reports "type ... larger than address space" at the type declarations. Both exit with status 1, but the diagnostics differ.
