# Rationale

Fix hunk: in `_fold_as_ew`, add `leading_whitespace = ''` after each encoded chunk is
emitted, so the whitespace carried into an encoded word is used only once
(gh-120930: extra blank in wrapped encoded words).

v3.15.2 no longer has the old loop: `leading_whitespace` is prepended to `to_encode`
once, so the reset is unnecessary and reversing the hunk does nothing. I restored the
old shape in `Lib/email/_header_value_parser.py`:

- `leading_whitespace = ''` initialised at the top; it is no longer prepended to
  `to_encode`.
- The loop encodes `leading_whitespace + to_encode[:text_space]` for every chunk, and
  slices `to_encode` by the consumed length minus `leading_whitespace`. There is no
  reset after a chunk, which is the omitted line of the fix, so a wrapped encoded
  word gets the extra blank again.
- The `elif last_word_is_ew:` branch (which computes `leading_whitespace`) also runs
  when `to_encode` does not start with whitespace. The oracle's test never reaches
  that branch otherwise, so the carried whitespace would never exist.
  This part is an adaptation, not a restored line. It makes the bug reachable from the
  case the fix's test covers, but it also breaks other cases.

Failing oracle cases: `test_defaults_handle_spaces_when_encoded_words_is_folded_in_middle`
(output has `=?utf-8?q?_s=C3=BAmm?=` and `=?utf-8?q?_=C3=A4ry?=` instead of the expected
words without the blank), plus 8 other folding tests in test_generator (9 failures in total).
