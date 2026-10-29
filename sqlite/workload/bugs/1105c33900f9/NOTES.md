Reproducer (repro.sql): a RIGHT JOIN whose ON clause references a table to its right (`t6.a`), inside an EXISTS subquery in the result list of an outer SELECT.

Clean shell: "ON clause references tables to its right" error, exit status 1.
Buggy shell: the check is skipped for the subquery, so the statement runs without error and exits 0.
