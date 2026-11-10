# Bug
util.inspect of an error whose `cause` is a throwing getter threw instead of printing `[cause]: [Getter]`, because getStackFrames read `err.cause` unguarded.

# Change (lib/internal/util/inspect.js, getStackFrames)
Single hunk, matching the fix's one implementation hunk: removed the `try { ({ cause } = err) } catch {}` block and went back to using `err.cause && isError(err.cause)` (and `getStackString(ctx, err.cause)`) directly, so a throwing getter propagates out of inspect.

# Failing test
message/util-inspect-error-cause: "not ok" — output length differs (expect=191, actual=53 lines), because inspect throws on the new throwing-cause case. Stable over two runs.
