Compiles a valid one-line module with `--noEmitOnError --isolatedModules`.
Clean: no diagnostics, emits out/input.js.
Injected: reports error TS5053 "Option 'noEmitOnError' cannot be specified with option 'isolatedModules'", so nothing is emitted.
