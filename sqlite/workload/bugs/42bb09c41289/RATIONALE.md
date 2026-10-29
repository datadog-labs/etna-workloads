# Rationale

Fix: in the stay-on-last-page optimization of `sqlite3BtreeIndexMoveto()`, clear
`BTCF_ValidOvfl` before `goto bypass_moveto_root` (OSSFuzz 45329).

In 3.54.1 the clear is merged into one statement,
`pCur->curFlags &= ~(BTCF_ValidOvfl|BTCF_AtLast);` (src/btree.c, ~line 6120).
I changed it to `pCur->curFlags &= ~BTCF_AtLast;`, so `BTCF_ValidOvfl` is no
longer cleared. This reverses the fix's added line. `BTCF_AtLast` is still
cleared because that is separate, later code and not part of this fix.

## Oracle result
`btree01-2.1` fails: `sqlite3BtreeIndexMoveto: Assertion
(pCur->curFlags & BTCF_ValidOvfl)==0 failed` (the assert after `bypass_moveto_root`).
