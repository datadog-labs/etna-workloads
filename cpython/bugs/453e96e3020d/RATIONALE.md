# Rationale
Reverts gh-111420: the parenthesized `with` alternative of `with_stmt` no longer accepts `TYPE_COMMENT?`.
- Grammar/python.gram: drop `tc=[TYPE_COMMENT]` and pass `NULL` type comment to `_PyAST_With` (fix hunk 1).
- Parser/parser.c (generated, hand-synced): remove the `tc` variable, the TYPE_COMMENT? match, and use `NULL` (fix parser.c hunks).
Oracle: test_type_comments.TypeCommentTests.test_parenthesized_withstmt fails with SyntaxError
on `with (a as b):  # type: int` (type comment unexpected).
