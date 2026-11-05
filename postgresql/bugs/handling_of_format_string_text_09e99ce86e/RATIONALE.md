# Rationale

## src/backend/utils/adt/formatting.c, DCH_from_char()
Traces to the single hunk of fix_impl.patch (text-character branch, `n->type != NODE_TYPE_ACTION`).

The fix made non-FX mode honour `extra_skip`: if extra input characters were already skipped
for earlier separators, a text character in the format does not consume another input
character, since that character may belong to the next field. I removed that logic, so in
non-FX mode a text character always consumes one input character (`s += pg_mblen_cstr(s)`).
The FX-mode branch, which has since gained the standard-mode strict-match check, is unchanged.
This brings back the original bug: when the input has more separators or spaces than the
format, text characters eat the start of the next field. For example, `to_timestamp` with
extra spaces before a literal text character in the format gives a wrong result or an error.

## Failing oracle cases
- src/test/regress||horology (confirmed FAIL with agent_oracle.py)
