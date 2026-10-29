Selects `b, ~b, NOT b` from a one-row table. With the bug, NOT/BITNOT code the operand
into the target register, overwriting the cached column `b`, so the later output is wrong.
Clean: `11|-12|0`; buggy differs (see check.sh output).
