repro.sql runs the upstream joins.slt test: a NATURAL JOIN between a Utf8 column and a Utf8View column (made with arrow_cast).

Clean build: returns the row 'foo'.
Buggy build: fails with a schema error ("No field named t2.v1"), because can_hash returns false for Utf8View.
