Watch-mode program (in-memory host, virtual cwd `/home/user/proj`, too shallow to be a watchable root) with `input.ts` importing a missing `./missing`.
The failed lookup `/home/user/proj/missing.ts` resolves to a non-recursive watch on the root dir itself.
Clean: watchers are created (`<root>/missing`, `<root>`, both non-recursive) and printed.
Injected: `Debug.assert(!nonRecursive)` fails, so `createWatchProgram` throws "Debug Failure. False expression."
