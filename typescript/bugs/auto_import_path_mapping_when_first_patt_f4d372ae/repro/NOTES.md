Language-service completions for `bar` in /package1/file1.js, which can auto-import `bar` from /package2/file1.js.
tsconfig paths: "package1/*" -> "./*" (tried first, yields a relative match "../package2/file1") and "package2/*" -> "../package2/*".
Clean: skips the first pattern and prints module specifier `package2/file1`.
Injected: the first pattern's relative match aborts the search, so no path-mapped specifier is printed (or a different one).
