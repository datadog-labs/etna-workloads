repro.sh recreates the PGO devirtualize testdata module with mult.MultFn changed from
concrete to generic, then builds with a PGO profile collected for the non-generic version.
Clean: build succeeds (exit 0). Buggy: internal compiler error
"mult.MultFn has 0+1 params, but instantiated with 0+0 args" (exit 1), because
noder.LookupFunc fatals instead of failing gracefully (issue 65615).
