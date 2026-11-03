repro.sh builds issue40917's program with -gcflags=-d=checkptr. It does `uintptr(p) &^ 1` on an unsafe.Pointer.
Clean: prints "ok". Buggy: checkptr falsely reports "pointer arithmetic result points to invalid allocation" (fatal error), because the &^ is lowered to & and no longer recognized.
