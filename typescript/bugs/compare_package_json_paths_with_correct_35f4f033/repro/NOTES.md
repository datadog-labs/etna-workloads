run.js compiles a small project through the API with an in-memory case-insensitive host (`useCaseSensitiveFileNames` false). Paths are mixed-case (`/Work/pkg1`), and the host canonicalizes them to lowercase.
Declaration emit has to write an `import("...")` type for `type-helpers`.
Clean: `import("./utils/type-helpers").R`. Injected: `import("src/utils/type-helpers").R`.
The injected build compares package.json paths with plain `!==`, so a case-only difference makes it treat the two files as being in different packages.
