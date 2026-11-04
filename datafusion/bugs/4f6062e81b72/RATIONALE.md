# Rationale

Fix hunk reversed: `datafusion/sql/src/statement.rs` (`insert_to_plan`), which added
`planner_context.set_table_schema(...)` with the target table's fields before planning the
INSERT source. I removed that call. The `Values` planning then goes through `infer_data`
(no table schema), which marks every column nullable and does not cast literals to the
target types. This is the pre-fix behaviour. The builder.rs hunks (`ValuesFields`) are
already present in 55.2.0 and are unchanged, so the only changed lines trace to this hunk.
(`DFSchema`/`DFSchemaRef` imports are still used elsewhere in the file.)

Oracle failures (insert.slt and insert_to_external.slt): the errors for
`insert into t(id) values(4,'zoo')` and for inserting NULL into a non-nullable column show
the old messages ("Column count doesn't match insert query!", "Invalid batch column at '0'
has null but schema specifies non-nullable") instead of the expected "Inconsistent data
length across values list" and "Column 'column1' is declared as non-nullable but contains
null values".
