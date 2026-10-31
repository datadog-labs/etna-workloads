# Rationale

Fix: gh-116764, parse_qsl() bytes branch. Pre-fix code was `qs = bytes(qs)`;
the fix added `if not qs: return []` and `bytes(memoryview(qs))`.

In v3.15.2 this logic lives in `Lib/urllib/parse.py` `parse_qsl` as the
`elif qs is None: return []` branch plus a `try: bytes(memoryview(qs)) except
TypeError` block (false values accepted with a DeprecationWarning). I removed
both and restored the plain `qs = bytes(qs)` in the bytes branch.

Effects (the regressions the fix corrected):
- `parse_qsl(None)` raises TypeError instead of returning [].
- `parse_qsl(list(b'a=b'))`, iterators, and non-zero ints are accepted by the
  bytes constructor instead of raising TypeError.

Failing oracle cases: `test_parse_qsl_false_value` (TypeError on None) and
`test_parse_qsl_errors` (TypeError not raised for list(b'a=b')).
