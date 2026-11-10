Incremental build (`tsc -p .` with `incremental` + `declaration`) of a file whose declaration emit fails with TS4094 (exported anonymous class with protected member), and a second file importing it.
Run 1 builds; then main.ts is edited and tsc is run again.
Clean: the second run re-reports the TS4094 declaration-emit errors (stored in buildinfo `emitDiagnosticsPerFile`). Injected: errors are not saved, so the second run omits them.
