# Re-introduced bug: sqlite constants not aggregated in a `constants` property

Before the fix, `node:sqlite` exposed its constants (SQLITE_CHANGESET_*) as loose top-level exports; the fix grouped them under `require('node:sqlite').constants`. With the bug, `constants` is missing and the constants are top-level again.

## Hunks
- src/node_sqlite.cc (Initialize): the fix creates `Object::New` and calls `DefineConstants(constants)`; reversed, `DefineConstants(target)` defines them directly on the binding target. Corresponds to the first Initialize hunk.
- src/node_sqlite.cc: removed `target->Set(context, env->constants_string(), constants)`, reversing the fix's last hunk (no `constants` property).
- lib/sqlite.js: today's code re-exports `constants` from the binding (didn't exist at fix time); it now re-exports the three top-level SQLITE_CHANGESET_{OMIT,REPLACE,ABORT} instead of `constants`.

## Failing tests
parallel/test-sqlite and parallel/test-sqlite-session fail: `constants` is undefined, so `constants.SQLITE_CHANGESET_OMIT` throws TypeError (Cannot read properties of undefined).
