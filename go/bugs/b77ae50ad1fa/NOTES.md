repro.sh builds a program that wraps `iter.Seq2[int, struct{}]` into `iter.Seq[int]` via range-over-func (the issue78599 test, made a main package).

Clean: compiles, exit 0. Buggy: internal compiler error "DwarfFixupTable has orphaned fixup ... keys.func1-range1". The injection reverts the filtering in `preInliningDcls`, so a zero-size variable is kept in the pre-inlining DWARF declarations.

It uses a private GOCACHE (`$PWD/gocache`) because the two toolchains otherwise share cached build results.
