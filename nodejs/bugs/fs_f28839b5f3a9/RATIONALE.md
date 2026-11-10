# Re-introduced bug: fs.glob returning duplicates (nodejs/node#50881)

**Bug.** Glob results were collected without de-duplication, so patterns that reach the same path through several branches (e.g. `a/{b/**,b/c}`) returned the same path more than once. The fix switched the results store from an Array to a Set.

**Today's code.** The release already has a `ResultSet` (a `SafeSet`), and the sync path (`globSync`) still de-duplicates through it. The async generator (`glob`) yields a path whenever `add()` returns true and relies on explicit `!this.#results.has(...)` guards to avoid yielding repeats. The old defect is therefore re-expressed by removing those guards.

**Changes (all in lib/internal/fs/glob.js, async `#iterateSubpatterns`-style generator).** Each `!this.#results.has(X)` guard was removed (8 sites: the final literal-pattern result, the trailing `**` result, `**` last, next-pattern-last, the `**/..` path and parent results, the `.` current-pattern result, and the regex-match last-pattern result). Each corresponds to a fix hunk that changed `ArrayPrototypePush(this.#results, X)` to `this.#results.add(X)`: the old code pushed unconditionally, which is the same as yielding unconditionally here. The guards were removed rather than the `ResultSet` class itself, so sync behaviour is unchanged.

**Failing test.** `parallel/test-fs-glob` fails (`not ok 1`) in two consecutive runs with `AssertionError [ERR_ASSERTION]: Expected values to be strictly deep-equal`; the actual output has an extra duplicate such as `'a/b/c'`.

**Note.** Removing the guards left bare `{ ... }` blocks where the `if` was, so lint (`no-lone-blocks`) may complain. This does not affect behaviour.
