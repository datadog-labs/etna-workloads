# Re-introduced bug (fix 219e9fe6: crash on multiline named cjs imports)

**Bug:** When a named import from a CommonJS module spans several lines, the error-decoration code in `ModuleJob._instantiate` (lib/internal/modules/esm/module_job.js) runs `/{.*}/` against the single stack line `splitStack[1]`. That line has no `{...}`, so the match is `null` and `null[0]` throws `TypeError: Cannot read properties of null (reading '0')` instead of the intended SyntaxError.

**Change (one hunk):** In the `if (isCommonJS)` block I removed the null-guarded `oneLineNamedImports` handling and TODO. It now does `RegExpPrototypeExec(/{.*}/, importStatement)[0]` unconditionally. The "For example" `import pkg ...; const {..} = pkg;` text is always appended. This matches the fix's hunk that made the example conditional on a match, reversed to the old unguarded code.

**Failing test:** `es-module/test-esm-cjs-named-error` is `not ok`, with `actual: TypeError: Cannot read properties of null (reading '0')` in the multi-line case. The test file in the tree does not contain the multi-line case, so the failure surfaces via the existing test's cases or fixtures. Stable across two runs.
