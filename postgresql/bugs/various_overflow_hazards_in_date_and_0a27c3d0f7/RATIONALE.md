# Rationale
Reverted overflow checks (all trace to fix.patch hunks):

- src/backend/utils/adt/date.c, make_date(): the pg_neg_s32_overflow hunk. It is back to `tm.tm_year = -tm.tm_year;`. The shared int.h helpers are left in place, since they are harmless.
- src/backend/utils/adt/formatting.c, DCH_from_char() (Y,YYY): `years += millennia * 1000` is unchecked again.
- formatting.c, do_to_timestamp(): `tmfc.ddd = (tmfc.ww - 1) * 7 + 1`, `tmfc.dd = (tmfc.w - 1) * 7 + 1` and `*fsec += tmfc.ms * 1000` are unchecked again. These correspond to the WW, W and MS hunks.

With these changes, signed integer overflow happens on huge inputs. The result is wrapped values and no error.

Failing oracle case: src/test/regress||horology. The date case still passes. make_date(INT_MIN) is still rejected downstream by ValidateDate, which reports a different error.
