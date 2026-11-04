repro.sql creates a table with a struct column, then self-joins it under aliases test1/test2 and filters on `test1.struct_field['substruct'] = test2.struct_field['substruct']` (plus nested variants).

Clean: the qualified column is resolved and each query returns the matching row.
Buggy: every query fails with "Schema error: No field named test1. Valid fields are test1.struct_field, test2.struct_field.", because the compound identifier's qualifier isn't recognised.
