repro.sql copies the SIMILAR TO cases from the fix's type_coercion.slt. It runs `'a' SIMILAR TO NULL` and variants, then a Utf8View, LargeUtf8 and Dictionary value against a non-scalar Utf8 pattern column, then `1 SIMILAR TO 'a'`.

df-clean evaluates them. The NULL cases return NULL, the array cases return true, and the last query gives the planning error "There isn't a common type to coerce Int64 and Utf8 in SIMILAR TO expression".

df-buggy has no coercion for SIMILAR TO operands. It panics in the regex kernel ("failed to downcast array") and exits with status 101.
