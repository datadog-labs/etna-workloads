# Rationale

Code is in `overlay_bounds` (datafusion/functions/src/core/overlay.rs). 55.2.0 had been rewritten (`apply_overlay` and the bulk builders), so the fix's `overlay_one` and `byte_index_for_char` hunks can't be reversed directly. I restored the pre-fix computation in `overlay_bounds`, which now returns the old values:

- Character counts and positions were mixed with byte offsets. The removed `byte_index_for_char` and the non-ASCII codepoint walk converted character indexes to byte offsets. The old code sliced `string[..start]` and `string[end..]` with character positions used as byte offsets. This panics inside a multibyte character or gives wrong results.
- The old code had no past-end handling. When `start_pos - 1 >= string_len`, no prefix was emitted. The fix's comment says the whole string is the prefix in that case. Here `prefix_end` is 0 when start is past the end, so `overlay('123' placing 'abc' from 4 ...)` returns `abc` instead of `123abc`.
- `start_pos < 1` still errors in `apply_overlay`. I did not revert that check.

## Oracle failure
`functions.slt` fails. The unicode case `overlay(str placing characters from pos for len)` over `'aébc'` panics with "end byte index 2 is not a char boundary". The past-end case `123abc` would also return `abc`.
