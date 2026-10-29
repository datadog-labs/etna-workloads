Creates an fts5 table named "My.Table" (name needs quoting) and runs `... MATCH 'table' ORDER BY rank`.
Clean shell returns the two rows ranked; the buggy shell builds the internal rank query with the unquoted table name as the rank-function argument and fails with a SQL error.
