# Rationale

In 55.2.0 the per-type `%c` match arms in the fix were refactored into the `IntegerFormatValue::to_char`
trait methods (`signed_integer_value!` / `unsigned_integer_value!` macros in
`datafusion/spark/src/function/string/format_string.rs`). The helpers `signed_to_char` / `unsigned_to_char`
(added by the fix) still exist, but `to_char` now calls them.

Change: both macro `to_char` bodies now do `Ok(char::from_u32(self as u32).unwrap())`, the pre-fix
unchecked `char::from_u32(..).unwrap()` (truncating cast, no validation). This reverses the fix hunks that
replaced `char::from_u32(...).unwrap()` with `signed_to_char`/`unsigned_to_char` in each arm.
The helpers are left in place (now unused by this path).

Oracle: `format_string.slt` fails on `SELECT format_string('Char: %c', -1);` — expected a SQL error, but
it panics with `called Option::unwrap() on a None value` (-1 as u32 = 0xFFFFFFFF is not a valid char).
