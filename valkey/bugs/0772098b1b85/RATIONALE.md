# Rationale
Reverts the overflow detection added by the fix (9.0.7 has it in different places):
- `t_string.c` `getExpireMillisecondsOrReply` (shared by SET and GETEX, which the fix patched separately as setGenericCommand/getexCommand): restores the `milliseconds <= 0` only check (drops the `unit == UNIT_SECONDS && ms > LLONG_MAX/1000` clause) and drops the pre-addition overflow check for relative EX/PX basetime (fix's `when <= 0` overflow check).
- `expire.c` `expireGenericCommand`: removes the unit-conversion overflow check and the basetime-addition overflow check (fix's `negative_when` sign-change check).

Oracle failures: "SET/GETEX with big integer", "EXPIRE with big integer overflows...", "PEXPIRE with big integer overflow when basetime is added", "GETEX and SET with relative expire overflow" etc. now get wrapped values instead of "invalid expire time" errors.
