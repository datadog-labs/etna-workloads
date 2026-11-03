repro.go refers to an unexported, nonexistent name in another package (`bytes.buffer`).
Clean toolchain reports one error ("undefined: bytes.buffer (but have Buffer)").
Buggy toolchain also reports an extra "name buffer not exported by package bytes" at the same position,
so the unexported-name error is emitted twice (the bug fixed by upstream "report error for unexported name only once").
