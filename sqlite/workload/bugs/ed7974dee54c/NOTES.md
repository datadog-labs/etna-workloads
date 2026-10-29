Creates a view named `IF` (a syntax error when the schema entry is re-parsed by OP_ParseSchema), then creates another table and lists sqlite_schema.
Without sqlite3MayAbort, no statement journal is made for OP_ParseSchema, so the failure leaves the schema inconsistent. Compare the outputs of the two shells with ./check.sh.
