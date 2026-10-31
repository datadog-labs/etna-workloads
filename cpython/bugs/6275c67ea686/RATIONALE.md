# Rationale

The C code (`extract_anchors_from_expr`) no longer exists in v3.15.2; only the
pure-Python `_extract_caret_anchors_from_line_segment` in `Lib/traceback.py`
remains, and it was rewritten. Fix hunk reversed: the `ast.BinOp` change that
skips `)` (and spaces/`#`) after the left operand to find the operator.

Change: in the `ast.BinOp` case, `increment_until(..., lambda x: not x.isspace() and x != ')')`
became `lambda x: not x.isspace()`. The first non-space character after the
left operand's end is again taken as the operator, so for `( a   )   + b`
the `)` is treated as the operator and the carets are misplaced.

The subscript hunk is not reverted: the current code already finds `[` with
`increment_until`, and removing that broke unrelated multiline cases.

Failing oracle cases: `test_caret_for_binary_operators_with_spaces_and_parenthesis`
(Pure/C/Legacy variants) get `~~~~~~~~~^~~`-style wrong carets, and the
multiline binary-operator tests (`..._multiline_two_char`, `..._with_unicode`,
`test_many_lines_binary_op`) also fail since they involve `)` before the operator.
