# Rationale

Fix gh-135307 changed `_encode_text` in `Lib/email/contentmanager.py` to use `maxlen = policy.max_line_length or sys.maxsize`. In v3.15.2 the fix is present, and the base64 path already uses `binascii.b2a_base64(..., wrapcol=...)` instead of the old `_encode_base64` helper. I reverted every use of `maxlen` to `policy.max_line_length`:

- Removed `import sys` and the `maxlen = ...` line. This reverses the fix's first two hunks.
- The 7bit heuristic is back to `max((len(x) for x in lines), default=0) <= policy.max_line_length`. This reverses the third hunk. With `None` it raises TypeError.
- `sniff_qp`, the quoted-printable branch and the base64 branch (`wrapcol=`) use `policy.max_line_length` again. This reverses the last three hunks. The base64 line is the v3.15.2 equivalent of the removed `_encode_base64(..., policy.max_line_length)` call.

## Oracle
`./check.sh` reports 2 errors in test_email.test_message (`test_no_wrapping_max_line_length`, with `max_line_length` 0 and None). They are the cases the fix added.
