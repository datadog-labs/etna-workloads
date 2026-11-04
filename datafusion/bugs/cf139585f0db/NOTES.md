repro.sql puts MAP literals with a NULL value (`MAP {'k1': NULL}`) and concretely typed maps in the same VALUES list, in both row orders, and also with a Float64 value.

- df-clean unifies the map types and returns the rows (the value type is widened to Int64 or Float64).
- df-buggy, with `map_coercion` removed from `type_union_resolution_coercion`, fails each statement with "Inconsistent data type across values list at row 1 column 0".
