repro.sql runs an implicit LATERAL UNNEST over a correlated outer column, which isn't supported in physical planning and errors out.
The error prints the OuterReferenceColumn payload. Clean build shows `Field { name: "column2", data_type: Int64 }`; buggy build shows only `Int64`, because the outer reference lost its full field (and metadata).
