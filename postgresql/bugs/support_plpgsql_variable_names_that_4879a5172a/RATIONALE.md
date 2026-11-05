# Rationale

Changed: `src/src/pl/plpgsql/src/pl_scanner.c`, function `plpgsql_yylex`, the "not A.B, so just process A" branch.

Traces to the pl_scanner.c hunk of fix_impl.patch (second hunk). I restored the old logic:
- At the start of a statement, when the next token is not `=`, `:=` or `[`, the scanner tries unreserved keywords first and then variable names.
- Otherwise it tries variable names first and then keywords.
- The fix replaced this with a single `plpgsql_parse_word(..., lookup, ...)` call that skips the variable lookup at statement start. That change lets variables be named like statement-introducing keywords.
- With the old logic restored, a variable whose name matches an unreserved keyword is mis-parsed as the keyword at statement start. Examples are variables named like `comment`, or other plpgsql unreserved keywords.

Not reverted: the `bool lookup` parameter of `plpgsql_parse_word` (pl_comp.c and plpgsql.h hunks). Every caller now passes `true`, so the parameter has no effect. The bug comes entirely from the scanner logic, so I left the signature alone to keep the change small.

Failing oracle case: `src/test/regress||plpgsql`
