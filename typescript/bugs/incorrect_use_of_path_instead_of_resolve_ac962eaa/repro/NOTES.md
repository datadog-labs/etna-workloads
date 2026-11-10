Three nodenext projects with references (tests -> logic -> core); `tsc -b` builds the .d.ts, then a watch program (createWatchProgram) on tests/tsconfig.json records which package.json files get watched.
Clean watches logic/package.json (affecting location of the redirected referenced file); injected keys the bookkeeping by `path` instead of `resolvedPath`, so logic/package.json is not watched.
