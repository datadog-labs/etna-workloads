Uses a tsserver ProjectService (public API) on an app whose node_modules/lib is a symlink to a project-referenced, unbuilt `lib` (source used instead of dist d.ts). After the first program, b.ts is edited to add `import ... from "lib/dist/index"`.
Clean: the import resolves via the symlink's real path (trailing separator kept), so only the expected type error is reported.
Injected: the symlink cache entry lacks a trailing separator, so the lookup breaks and a spurious "Cannot find module 'lib/dist/index'" error appears.
