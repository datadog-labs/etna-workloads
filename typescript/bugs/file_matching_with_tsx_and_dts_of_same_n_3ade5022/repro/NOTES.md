Project has a.tsx and a.d.ts with include ["*.tsx", "*.d.ts"]; `tsc -p --listFilesOnly` lists the matched files.
Clean: only a.tsx (a.d.ts is dropped as lower priority than same-named a.tsx).
Injected: both a.tsx and a.d.ts are listed, since .d.ts wrongly matches the ".ts" extension and is never filtered.
