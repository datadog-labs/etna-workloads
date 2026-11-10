# Rationale

**Bug:** `test/reporters` was not in the scheme-only builtin list, so `require('test/reporters')` / `import 'test/reporters'` resolved to the builtin without the `node:` scheme, shadowing `node_modules/test/reporters`.

**Hunk:** `lib/internal/bootstrap/realm.js` — fix added `'test/reporters'` to `schemelessBlockList`. In today's code that list is derived from `builtinModulePolicies` (second field = schemeOnly), so I changed the `['test/reporters', true, null]` entry to `false`. Thus it is no longer blocked without scheme (pre-fix behaviour).

**Failing test:** `parallel/test-runner-import-no-scheme` — `not ok`; AssertionError at test(): expected stdout `'{ marker: 1 }'` (node_modules package) but got the builtin reporters object `{ dot, junit, spec, tap, lcov }`. Ran stably.
