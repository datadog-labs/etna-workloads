Reproducer: repro.sh builds issue67329's package with `-gcflags=-d=ssa/check_bce/debug=1`.
Clean: checkbce runs after late fuse, so no bounds check remains in Found -> no diagnostics.
Buggy: checkbce runs before late fuse, so it reports `./x.go:6:11: Found IsInBounds`, a bounds check that is later eliminated.
