# Rationale (gh-143935, email comment folding)

v3.15.2 already contains both fix hunks in `Lib/email/_header_value_parser.py`; I reverted both.

1. `_refold_parse_tree`: removed the `if part.token_type == 'comment':` block that wraps the
   comment's parts in `(` / `)` terminals and escapes ptext with `make_parenthesis_pairs`.
   This reverses the fix's added block. Without it, a comment is unpacked into bare pieces with
   no parentheses, so a forced wrap of an unbreakable comment loses the required leading space.
   `make_parenthesis_pairs` is left defined (the fix's helper hunk), but is now unused.
2. `WhiteSpaceTerminal.startswith_fws`: restored `return True` (the fix changed it to
   `return self and self[0] in WSP`). Whitespace terminals that are empty or don't start with
   whitespace are then treated as folding whitespace again.

## Oracle result
`TestFolding.test_address_list_with_long_unwrapable_comment` fails (1 of 389 oracle cases).
The folded output no longer preserves the parentheses of the comment.
