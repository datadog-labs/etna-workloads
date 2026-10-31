Reproducer: renders a traceback frame whose source line is cached as a comment
(empty AST body) while the code has column offsets. The clean interpreter prints
the frame; the buggy one raises IndexError from `tree.body[0]` in
`StackSummary._should_show_carets` (missing `if not tree.body: return False`).
