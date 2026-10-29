Reproducer: DROP CONSTRAINT on constraints followed by DEFAULT/COLLATE (case 6) or by
FOREIGN KEY (case 7), from altercons2.test. The buggy shell mis-edits or errors on the
schema text; the clean shell leaves `b COLLATE nocase CHECK (a!=b), c DEFAULT 'abc'` and
`FOREIGN KEY(a) REFERENCES d` intact.
