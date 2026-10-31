# Rationale

Hunk reversed: `Python/symtable.c`, `symtable_visit_stmt`, `Try_kind` and `TryStar_kind`.
The fix moved `VISIT_SEQ(... orelse)` after `VISIT_SEQ(... handlers)`. In v3.15.2 the
code (now wrapped in ENTER/LEAVE_TRY_BLOCK) already had the fixed order, so I restored
the old order: the `else` block is visited before the exception handlers, in both
Try and TryStar. Only the visit order changes.

Oracle failure: `test_compile.TestSpecifics.test_global_declaration_in_except_used_in_else`
fails with `SyntaxError: name 'a' is used prior to global declaration`
(`global a` in the handler after `print(a)` in the else block was visited first).
