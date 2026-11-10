Language-service script (run.mjs) with `rootDirs` = /repo/src1 and /repo/src2, both containing a `dir/` folder. It requests completions for `import * as x from "./` in /repo/src2/index.ts.
Clean: the `dir:directory` entry appears once (completions from the rootDirs are de-duplicated).
Injected: `dir:directory` appears twice, once per root dir, because the deduplicate call was removed.
