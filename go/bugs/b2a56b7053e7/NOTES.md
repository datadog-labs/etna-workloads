repro.sh compiles a package whose function switches on `"" < string(p)` (p is []byte).
Buggy toolchain: walk's backingArrayPtrLen returns un-typechecked nodes, so the compiler fails (internal compiler error). Clean toolchain compiles fine (exit=0).
