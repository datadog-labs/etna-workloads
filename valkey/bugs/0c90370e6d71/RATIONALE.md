# Rationale

## Changed hunk
`src/ziplist.c`, `ziplistValidateIntegrity`: removed the check
`if (p != zl + bytes - ZIPLIST_END_SIZE) return 0;` after the entry loop.

This reverses the fix's ziplist.c hunk ("Validate ziplist tail followed by
extra data which start with 0xff"). In 9.0.7 the code is the same check, only
written on one line. Without it, a ziplist whose entry walk stops at an early
0xff terminator, with extra trailing data after it, passes deep sanitization.

## Oracle failure
`corrupt payload: fuzzer findings - quicklist ziplist tail followed by extra
data which start with 0xff` fails. RESTORE returns 'OK' where the test expects
"Bad data format". The other 88 cases still pass.
