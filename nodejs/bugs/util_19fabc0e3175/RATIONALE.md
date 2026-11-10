# Rationale

**Bug:** util.inspect on an Error whose non-string `stack` (e.g. an array with a Symbol) was stringified with `String()`, which throws a TypeError for Symbols; the output was wrong/crashing instead of formatting the value.

**Change (lib/internal/util/inspect.js, `getStackString`):** corresponds to the fix's `getStackString` hunk. The fix returns string stacks as-is and formats non-string stacks via `formatValue`. The release's version had grown (try/catch around the getter, seen/indentation handling, `ErrorPrototypeToString` prefix). I replaced the non-string branch with the old `return String(stack);`. The `ctx` parameter and callers are unchanged (callers already pass ctx, so no other hunks are needed).

**Failing test:** `parallel/test-util-inspect` fails (both runs): the release wraps the call in try/catch, so inspect returns `[object Error]` rather than throwing; the test expects `'[[\n  Symbol(foo)\n]]'`, and the err.name=array case yields a different stack format.
