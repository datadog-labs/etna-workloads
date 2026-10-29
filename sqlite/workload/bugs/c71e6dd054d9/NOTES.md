Reproducer: create a table with a quoted-name CHECK constraint, then run
`ALTER TABLE ... DROP CONSTRAINT "BooleanZeroOrOne"` and print the schema.
Clean shell drops the constraint (schema shows only the column). The buggy shell
doesn't dequote the constraint name, so it fails to find the constraint (error / unchanged schema).
