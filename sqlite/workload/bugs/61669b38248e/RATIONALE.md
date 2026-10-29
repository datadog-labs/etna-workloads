# Rationale

Fix (ticket #3257): arithmetic operators (OP_Add etc.) now call applyNumericAffinity()
on both operands so that a string operand converts to an integer when possible,
instead of always going through a double (losing precision for e.g. '9223372036854775807').

In 3.54.1 the equivalent logic is `computeNumericType()` in src/vdbe.c, called via
`numericType()` from OP_Add/Subtract/Multiply/Divide/Remainder for string/blob operands.
It tries `sqlite3Atoi64()` to yield MEM_Int. I removed that integer attempt, so string
operands always get MEM_Real (the pre-fix string->float behaviour). The BLOB
ExpandBlob path is unchanged.

Oracle failures: expr-13.2 and expr-13.3 (`0+'9223372036854775807'` and
`'9223372036854775807'+0` give 9.22337203685478e+18 instead of 9223372036854775807).
