# Re-introduced bug: missing hint in ERR_INVALID_PACKAGE_TARGET

Bug: when a package `exports` target is a string not starting with `./` (e.g. `"invalid5.js"`), the
ERR_INVALID_PACKAGE_TARGET message should say `; targets must start with "./"`. Before the fix, the message
gave no such hint, leaving the programming error unexplained.

Change (lib/internal/errors.js, one hunk in the ERR_INVALID_PACKAGE_TARGET message function): removed the
`relError` computation and the `${relError ? '; targets must start with "./"' : ''}` suffixes from both the
`key === '.'` message and the general message. This mirrors the fix's hunk that added `relError` and the
suffixes/extra branch (re-expressed for today's merged main/subpath code, which uses `relError` in two places).

Failing test: es-module/test-esm-exports (`not ok`), since the assertion
`assertIncludes(err.message, 'targets must start with')` for `pkgexports/invalid5` no longer holds.
Stable across two runs.
