main.ts reads `types.c` through a namespace import, where types.ts does `export type * from './values'` (c is a value).
Clean build reports TS2339 (property 'c' does not exist on typeof import("types")).
Injected build reports no error and exits 0.
