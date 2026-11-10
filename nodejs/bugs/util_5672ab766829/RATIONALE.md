# Re-introduced bug: util.inspect() options can tamper with internals

**Bug.** User options passed to `util.inspect()` were copied wholesale onto the internal `ctx`, so a user could override internal state (`seen`, `budget`, `indentationLvl`, ...), e.g. `util.inspect(obj, {seen: null})` breaks/changes formatting. Custom inspect functions also received a copy of the whole ctx instead of a whitelist of documented options.

**Hunks (lib/internal/util/inspect.js).**
1. Option loop in `inspect()` (fix hunk 2): restored `ctx[key] = opts[key]` for every user key, dropping the `inspectDefaultOptions`/`stylize` filter and the `ctx.userOptions` passthrough.
2. `getUserOptions()` (fix hunks 1 and 3): restored the old behaviour of handing the custom inspector `ctx` minus `budget`, `seen`, `indentationLvl` (`const {budget, seen, indentationLvl, ...ret} = ctx`) rather than the whitelist of default options + `userOptions`. The cross-context sanitising is kept.

**Failing test.** `parallel/test-util-inspect` reports `not ok` (stable over repeated runs). Observed failure at test/parallel/test-util-inspect.js:1114: `AssertionError: Expected values to be strictly deep-equal` - the option set passed to a custom inspect function is `Set(13)` instead of the expected `Set(14)` (missing `currentDepth`), since the whitelist is gone and the options object now mirrors raw internal ctx. The test's `{ customInspectOptions: true, seen: null }` case also exercises the overwrite of internal `seen`.
