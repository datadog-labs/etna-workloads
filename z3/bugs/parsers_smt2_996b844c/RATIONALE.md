# Rationale
Single hunk in src/src/parsers/smt2/smt2scanner.cpp (read_quoted_symbol), tracing to the smt2scanner.cpp hunk of FIX.diff.
Today's code rejects '\' in quoted symbols outright; the fix made '\|' and '\\' escapes handled properly. I restored the pre-fix scanning: an 'escape' flag set after any backslash, '|' ends the symbol only when not escaped, and backslashes are pushed verbatim without collapsing '\\' / '\|' (so |a\||, |a\\| are mis-parsed). test_symbol_escape in smt2print_parse fails.

Final check.sh output:
FAIL smt2print_parse (rc=114)
