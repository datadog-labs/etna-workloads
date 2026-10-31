# gh-104016 reintroduced (f-string tokenizer nesting off-by-one / overflow)

Changes (Parser/lexer/lexer.c, Parser/lexer/state.h; tokenizer.c/.h moved there in 3.15):
- Removed the `tok_mode_stack_index + 1 >= MAXFSTRINGLEVEL` check before `TOK_NEXT_MODE` in
  the f-string start path: reverses the fix's added "too many nested f-strings" check.
- `tok_mode_stack[MAXFSTRINGLEVEL]` -> `tok_mode_stack[MAXLEVEL]`: reverses the array-size hunk
  (pre-fix size was MAXLEVEL). MAXFSTRINGLEVEL define is left in place (unused now).
- Debug asserts in TOK_GET_MODE / TOK_NEXT_MODE restored to `< MAXLEVEL` (old, off-by-one for NEXT_MODE).

Oracle failures: test_fstring_nested_too_deeply (no "too many nested f-strings" error for 160 levels),
test_syntax_error_in_nested_fstring (nesting beyond the stack -> out-of-bounds write/crash; run
aborted with a crash, so later cases also show as failing).
