# Rationale
The fix (PR#6521) replaced the locale-dependent `is_printable` check in `escaped` with the fixed ASCII range `' ' .. '~'`.
Today's code already has the ASCII ranges (and `caml_is_printable` is gone), so I re-introduced a non-ASCII notion of "printable" (as a Latin-1 locale would give).

Hunks, all in `ocaml/stdlib/bytes.ml` (`unsafe_escape`), reversing the fix hunks `@@ -151,7 +150,8 @@ let escaped s =` and `@@ -168,19 +168,16 @@ let escaped s =` in stdlib/bytes.ml:
1. length counting: `| ' ' .. '~' -> 1` became `| ' ' .. '~' | '\160' .. '\255' -> 1`.
2. copy loop: `(' ' .. '~') as c` became `(' ' .. '~' | '\160' .. '\255') as c`.

Commands: `make clean && make -j8 && make -j8 ocamltest` (ok), then `sh run-oracle.sh`:
tests/lib-string/test_string fails with `Failure("test:String.escaped")`.
