repro.sh builds a two-package module (a with var s, main linknaming s to m/a.s, with a.Get inlined) based on test/fixedbugs/issue42401.
Clean: prints "ok". Buggy: the linkname'd symbol is not marked non-package, so main's s is not deduped with a.s and the program panics (FAIL1: a.Get() returns "" because a.s and main's s are distinct).
