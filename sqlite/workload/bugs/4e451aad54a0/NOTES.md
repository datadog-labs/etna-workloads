Reproducer (repro.sql): creates a TEMP trigger on aux1.t1, then a main-db view named t1, then a failing
CREATE VIRTUAL TABLE (forces a schema reload) and CREATE TABLE t3.
Clean shell: CREATE TABLE t3 succeeds. Buggy shell: it fails with
"malformed database schema (r1) - cannot create BEFORE trigger on view: t1" because the
temp-trigger orphan suppression is missing for the view/virtual-table error paths.
