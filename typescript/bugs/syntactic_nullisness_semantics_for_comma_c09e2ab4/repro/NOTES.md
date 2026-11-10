Input uses `(i++, maybe) ?? true` where `maybe` is `true | null`.
Clean: no diagnostics (comma's right operand `maybe` determines nullishness).
Injected: reports TS2869 "Right operand of ?? is unreachable" because the comma is treated as never nullish.
