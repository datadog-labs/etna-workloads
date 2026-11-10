Language-service completions for `import ... from "./` in /repo/src1/dir/test1.ts with rootDirs `["/repo/src1", "/repo/src2/"]` (one without, one with trailing slash).
Clean: merged completions from both root dirs: `f1,f2,test2`.
Injected: rootDirs are no longer given a trailing separator (off-by-one in getBaseDirectoriesFromRootDirs), so the relative directory is wrong and only `f1` is returned.
