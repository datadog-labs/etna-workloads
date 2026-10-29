# Rationale

## Change: src/insert.c, xferCompatibleCheck()
Removed the block "Default values for second and subsequent columns need to
match" (the `zDflt`/default-expression comparison inside the per-column loop).
This reverses the fix hunk that added the check
`(pDestCol->zDflt==0)!=(pSrcCol->zDflt==0) || strcmp(...)` -> `return 0`.
In 3.54.1 the default is held as a TK_SPAN Expr rather than `zDflt`, and the check
is restricted to i>0 and non-generated columns, but it is the same defect: the
xfer optimization is allowed between tables whose column defaults differ.
Pre-fix behaviour is exactly "no default comparison".

## Oracle failures (test/tkt-f67b41381a.test)
- 1.0: after ALTER TABLE ADD COLUMN b DEFAULT 2, `INSERT INTO t2 SELECT * FROM t1`
  copies raw records and yields `1 {}` instead of `1 2`.
- 2.2, 2.4, 2.8: xfer optimization is used despite differing defaults
  (`b DEFAULT 'x'` vs none; `DEFAULT NULL` vs none; and the matching 2.8 case).
