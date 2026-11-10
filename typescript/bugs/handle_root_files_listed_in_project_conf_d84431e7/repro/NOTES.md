Project `server` (composite) lists `../shared/src/**/*.ts` as root files, and references project `shared`.
`tsc -b server` then `tsc -p server --listFilesOnly` lists the files in the program.
Clean: root files from the referenced project are redirected to their output `shared/dist/src/*.d.ts`, as if imported.
Injected: those roots stay as the source `shared/src/*.ts` files (no redirect for root files).
