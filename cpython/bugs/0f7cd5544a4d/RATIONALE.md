# Rationale

Fix gh-144156 is reverted in `Lib/email/_header_value_parser.py` by restoring
the pre-fix `leading_whitespace` mechanism in place of `last_word_is_ew`
(all hunks of the fix in this file; `_WSP` constant is left, it is harmless):

- `_refold_with_ew`: `last_word_is_ew` init/updates removed; `leading_whitespace`
  init, reset before the "fits on next line" check, accumulation after
  `lines.append(newline + tstr)`, and passing it to `_fold_as_ew` restored.
  (Reverses the hunks in `_refold_parse_tree`.)
- `_fold_as_ew`: parameter back to `leading_whitespace`; the `elif last_word_is_ew`
  branch (encode inter-word whitespace in the second encoded word) removed;
  `text_space` again subtracts `len(leading_whitespace)`; the whitespace is
  encoded as its own encoded word at the start of continuation lines; when no
  text space remains, `lines.append(' ')` again (no `_steal_trailing_WSP_if_exists`,
  no `new_last_ew` update), which reintroduces the spurious space in `Subject: `.

## Failing oracle cases
- test_generator `test_defaults_handle_spaces_at_start_of_continuation_line_2` (and
  `test_ew_folding_round_trip_2` in the run output): folding between non-encoded and
  encoded words no longer matches / round trip loses whitespace.
- test_headerregistry `test_fold_unstructured_with_overlong_word` and
  `..._with_two_overlong_words`: output `'Subject: \n =?utf-8?...'` instead of `'Subject:\n ...'`.
- test_policy `test_non_ascii_chars_do_not_cause_inf_loop`: same spurious space after `Subject:`.
