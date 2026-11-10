# Re-introduced bug: TypeScript syntax errors lack snippet / `[eval]` name

Bug: errors for invalid/unsupported TypeScript syntax were thrown without the
amaro filename/line/snippet header, and eval paths passed the internal eval
URL as the filename instead of `[eval]`.

Hunks:
- lib/internal/modules/typescript.js: `parseTypeScript` throws plain
  ERR_UNSUPPORTED/INVALID_TYPESCRIPT_SYNTAX again, and `decorateErrorWithSnippet`
  is removed (fix hunks 1 and 2 reversed). No snippet is prepended to stack.
- lib/internal/process/execution.js: `kEvalTag` removed; all
  `stripTypeScriptModuleTypes` calls use `getEvalModuleUrl()` (or the url) as before
  (reversal of the kEvalTag hunks; a few call sites differed in today's code).

Failing test: es-module/test-typescript-eval ("the error message should not
contain extra padding" - stderr first line is no longer `[eval]:1   `);
fails in 2 of 2 runs.
