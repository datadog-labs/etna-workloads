Reproducer (repro.sql): a column with INT affinity and NOCASE collation holds the text './'.
`WHERE c0 LIKE './'` should return './'. The buggy shell applies the LIKE optimization,
because the check on the character before the upper bound ('.'+1 == '/') is wrong, and it returns no rows.
The clean shell returns './'.
