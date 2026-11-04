repro.sql calls array_append/array_prepend on lists whose inner field is custom
(`List(Int64, field: 'element')`) or non-nullable (`LargeList(non-null Int64)`).

df-clean returns the array and a type that preserves the input's inner field.
df-buggy fails each query with an "Internal error: Assertion failed:
result_data_type == *expected_type", because the function returns a list with
the default nullable `item` field instead of the planned type.
