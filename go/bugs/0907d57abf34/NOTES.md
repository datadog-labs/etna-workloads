repro.sh builds a program declaring a constant of an instantiated generic type (`const C T[int] = 3`) with `-gcflags=-N` (DWARF const info is emitted).
Clean: builds fine (exit 0). Buggy: the compiler no longer emits the type symbol, so the linker fails with
`go:constinfo.main: relocation target go:info.main.T[int] not defined` (exit 1).
