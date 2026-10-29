# Rationale

Fix (2008-03-26): make sure a column-count imbalance in a compound SELECT is
detected and reported before it causes an assertion fault / array overflow in
the code generator. The original fix added `SelectDest.nMem` and made
`selectInnerLoop` bail out when the register count mismatched.

In 3.54.1 that mechanism no longer exists. The same defence now lives in
`src/resolve.c` (`resolveSelectStep`): a check that each term of a compound
SELECT has the same number of result columns as `p->pNext`, calling
`sqlite3SelectWrongNumTermsError()`.

## Change
`src/resolve.c`: removed that check. This restores the pre-fix state, where a
column-count imbalance is not caught before code generation, so
`multiSelect()` / `selectInnerLoop()` run on mismatched select lists. It is the
modern counterpart of the fix's `nMem` guard: the early detection of the imbalance.

## Oracle
`select4-5.3` (and the select4-11.x cases, which are the fix's own tests)
fail: `multiSelect: Assertion 'p->pEList->nExpr==pPrior->pEList->nExpr' failed`
instead of the "do not have the same number of result columns" error.
