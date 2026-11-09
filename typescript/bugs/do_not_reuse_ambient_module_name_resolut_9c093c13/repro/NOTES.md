Builds three programs in memory with `ts.createProgram` (each reusing the previous as oldProgram, with `traceResolution`). `node.d.ts` declares `module 'fs'`; `app.ts` imports `fs`. In the third program `app.ts` changes and `node.d.ts` stops declaring `fs`.
Clean: re-resolves `fs` for `app.ts` (trace shows "Resolving module 'fs'... was not resolved").
Injected: reuses the stale ambient declaration from the old program and traces "Module 'fs' was resolved as ambient module declared in '/p/node.d.ts' since this file was not modified." instead of resolving.
