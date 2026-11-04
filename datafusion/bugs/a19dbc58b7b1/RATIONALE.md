# Rationale

Fix: `regexp_count` counted nothing for an empty pattern or empty value (`None | Some("") => 0`). 55.2.0 was refactored (NULL handling, `start_to_byte_offset`), so the old hunks no longer apply. The empty-string short-circuits are re-added in `datafusion/functions/src/regex/regexpcount.rs`:

- Scalar regex: after `regex_scalar` is computed, an empty regex returns 0 for every row. This reverses the `None | Some("") => zeros` arms in the four scalar-regex cases.
- Array regex (3 arms: `(None,true,true)`, `(None,false,true)`, `(None,true,false)`, `(None,false,false)`): an empty regex returns `Some(0)`. This reverses `None | Some("") => return Ok(0)`.
- `count_matches`: an empty value returns `Some(0)`. This reverses `None | Some("") => return Ok(0)` for the value.

The fix's `start` char-offset hunk is not reverted, because `start_to_byte_offset` already handles it correctly. It was not part of the bug in this form.

## Oracle failures
`regexp_count.slt` fails on `regexp_count('abc','')` (expected 4, got 0), `('abc','',2)`, `('abc','',1,'i')`, `('abc','',4)`, `('','')` and `('😀','',2)`.
