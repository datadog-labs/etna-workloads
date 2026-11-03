repro.go is the upstream test issue23536.go: it converts a slice of a user-defined byte type (`[]MyByte`) and of a user-defined rune type (`[]MyRune`) to string, discarding the results.

Clean toolchain: compiles and runs with no output.
Buggy toolchain: the missing OCONVNOP in typecheck makes the compiler fail with
`cannot use <node SPTR> (type *MyByte) as type *byte in argument to runtime.slicebytetostring` (and the matching error for `slicerunetostring`).
