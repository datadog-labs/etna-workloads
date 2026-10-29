Reproducer (repro.sql): in a UTF-16 database, compares CAST(X'310032003300' AS TEXT)
with CAST(substr(X'310032003300',1) AS TEXT) (cast-8.2). Clean shell prints 1; buggy
prints 0, because sqlite3VdbeChangeEncoding no longer sets pMem->enc for non-string
values, so the substr() blob result carries a stale encoding when cast to TEXT.
