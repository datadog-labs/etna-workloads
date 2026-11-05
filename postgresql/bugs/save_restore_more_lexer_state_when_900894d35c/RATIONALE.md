# Rationale

Changed file: src/bin/psql/command.c

- `save_query_text_state()`: traces to the command.c hunk in fix.patch. It again saves only the lexer paren depth (`conditional_stack_set_paren_depth(psql_scan_get_paren_depth())`) instead of the full lexer state (paren_depth, begin_depth, identifier_count, identifiers).
- `discard_query_text()`: traces to the second command.c hunk. It restores only the paren depth. As a result, begin_depth and the identifier tracking are not restored after text is skipped in an inactive `\if` branch.

The lex_state helper functions stay in the tree but are unused. The fix's other hunks only add those helpers.

Failing oracle case: src/test/regress||psql
