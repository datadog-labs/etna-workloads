# Rationale

Fix (gh-88233) added the trailing `buffer.append(extra[start:])` in `_strip_extra`, so
extras after a zip64 extra are preserved. In v3.15.2 `_strip_extra` was rewritten as
`_Extra.strip` (Lib/zipfile/__init__.py), which keeps every field whose id is not in `xids`.

Change: `_Extra.strip` now stops at the first field whose id is in `xids` and drops it and
everything after it. This restores the original symptom: "any data after the zip64 extra is removed".

Oracle failures: `StripExtraTests` (test_no_data, test_with_data, test_multiples, ...) fail,
e.g. `strip(a+b+c)` returns `b''` instead of `b+c`.
