repro.go inlines functions whose `if x || true { return true }; return true` has a statically-true condition (issue #62211).
Clean toolchain: compiles and prints "f ok" / "g ok" (exit 0).
Buggy toolchain: compiler fails with "internal compiler error: 'main': value ~r0 (v37) incorrectly live at entry" (exit 1),
because the always-taken `if` isn't flattened, so phi insertion thinks the inlined result temp may be uninitialized.
