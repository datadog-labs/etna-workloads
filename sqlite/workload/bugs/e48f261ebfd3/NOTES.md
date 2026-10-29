Creates a table whose generated columns use `GENERATED ALWAYS`, then lists column types via pragma_table_xinfo.
Clean shell strips the "generated always" text from the typename (b=int, c=text, d empty); the buggy shell leaves it in the type (e.g. "int generated always").
