Reproducer (repro.sql): FTS3 table with a doc where "alpha" and "beta" are 20 tokens apart.
`MATCH 'alpha NEAR/19 beta'` and `NEAR/000019` should return docid 1 (clean does).
The buggy shell returns no rows, because NEAR ranges above 9 are mis-parsed (nNear stored in a signed char / only one digit parsed).
