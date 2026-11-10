Input: an ESM package (type: module, main, no exports) in node_modules, imported from an ESM file under module node16, via the subpath 'pkg/dist/dir' that is a directory with index.d.ts.
Clean: reports error TS2307 (directory module lookup not allowed in ESM mode).
Injected: the directory import resolves silently (no error, exit 0).
