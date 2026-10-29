# Rationale

Fix hunk reversed: `windowCodeRangeTest()` in src/window.c. The fix added a check
that skips the `+/- regVal` arithmetic when csr1's peer value is a text or blob
(compare against `''` via OP_String8 / OP_Ge, then `sqlite3VdbeJumpHere`).

In 3.54.1 I removed that check: the `regString` register, `addrGe`, the OP_String8,
the OP_Ge skip-jump and the JumpHere. The arithmetic is now applied to every
peer value, as it was before the fix. Text values are coerced to numbers
(`'a'+1` = 1), so RANGE offset frames over string/blob values compare against the
wrong boundary.

The other fix hunks do not apply to the current code. The parse.y `frame_exclude_opt` and
window.c comment hunks are cosmetic, and the OP_Rowid tiebreak was already gone.
The NULL handling (OP_IsNull/OP_NotNull) in 3.54.1 is the BIGNULL block, which is
separate and left untouched.

Failing oracle cases (window1.test): 19.2.2, 19.3.2, 20.2.2, 20.3.2, 28.2.2, 29.2.
These are the DESC-ordered RANGE tests with mixed numeric and string values; the string rows get
wrong frame boundaries. The ASC variants still pass, because the early OP_Ge compare happens before the arithmetic.
