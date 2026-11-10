Project with package.json `imports` ("#indirect1") and a self-name import ("pkg/indirect2.js" via `exports`), module nodenext.
Both resolve to project source files, so they must not be treated as external library imports and must be emitted.
Clean: dist/ contains indirect1.js, indirect2.js and main.js. Injected: only main.js is emitted (the two files are marked external library imports).
