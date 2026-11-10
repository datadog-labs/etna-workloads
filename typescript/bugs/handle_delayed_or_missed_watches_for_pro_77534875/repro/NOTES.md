Uses ts.createWatchProgram with an in-memory sys (tsconfig including **/*, initial file /p/b.ts), then creates /p/sub/a.ts
and delivers only the file-level recursive directory-watch event (the "sub" directory event is missed).
Clean: the cached directory host clears the first cached ancestor entry, so the program reloads and includes /p/sub/a.ts.
Injected: the stale cache is kept, so the program still contains only /p/b.ts.
