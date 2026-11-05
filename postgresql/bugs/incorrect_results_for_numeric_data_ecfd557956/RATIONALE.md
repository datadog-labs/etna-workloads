# Rationale

File: src/interfaces/ecpg/ecpglib/sqlda.c. Three hunks, each from fix.patch:

1. `sqlda_common_total_size()`, case ECPGt_numeric: the space reserved for the digits array is again `num->ndigits + 1`. It was `num->digits - num->buf + num->ndigits`.
2. `ecpg_set_compat_sqlda()`, case ECPGt_numeric: the aligned size and the memcpy length are again `num->ndigits + 1`.
3. `ecpg_set_native_sqlda()`, case ECPGt_numeric: same change as hunk 2.

Why this brings the bug back: `num->digits` can point past `num->buf`, because leading zero digits are skipped. The buffer therefore holds `digits - buf + ndigits` bytes. Sizing and copying only `ndigits + 1` bytes truncates the tail of the digit data. The SQLDA then holds wrong numeric values.

The `if (num->buf)` guards in today's code are unchanged. fix.patch removed an older `if (num->ndigits)` guard, which no longer exists in this form.

Failing oracle case: src/interfaces/ecpg||sql/sqlda
