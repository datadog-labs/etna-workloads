# Bug
`import.meta.resolve(new URL(...))` fails when async loader hooks (`module.register`) are active: the URL object is passed unstringified to the hooks worker and can't be structured-cloned (`DataCloneError: Cannot clone object of unsupported type`).

# Change
`lib/internal/modules/esm/loader.js`, `ModuleLoader.resolveSync`: `const specifier = \`${request.specifier}\`;` -> `const specifier = request.specifier;`. This corresponds to the fix's `originalSpecifier = \`${originalSpecifier}\`` hunks in `resolve`/`resolveSync` (the code was refactored; `resolveSync` is now the single place where the specifier is coerced before reaching `asyncLoaderHooks.resolveSync`). The coercion is removed, restoring the old behaviour. (The `resolve` hunk has no direct equivalent in the current code.)

# Failing test
`es-module/test-esm-import-meta-resolve` — not ok: AssertionError, stderr contains `DOMException [DataCloneError]: Cannot clone object of unsupported type.` rather than being empty (the new URL-instance subtest).
