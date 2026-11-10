# Rationale

**Bug:** `util.inspect` of errors did not always show the `cause` property. Since `cause` is non-enumerable by default, errors with a cause printed without any `[cause]: ...` section.

**Change (lib/internal/util/inspect.js, formatError):** removed the block that pushes `'cause'` onto `keys` when the error has an own `cause`. This matches the fix hunk in `formatError` that added `if (err.cause && ...) keys.push('cause')`. Before the fix, no such code existed, so the non-enumerable cause was hidden. The stack-frame dedup helpers (getStackFrames/identicalSequenceRange) are left in place, since without the cause being visualized they only matter for the top-level error.

**Failing test:** `message/util-inspect-error-cause` fails (`not ok 1`) because the output has no `[cause]` sections. It failed in both runs.
