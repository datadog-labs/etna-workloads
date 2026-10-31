# NOTES

`repro.py` calls `http.cookiejar.http2time()` with the malicious date string
from the upstream bpo-38804 report: `"1-c-1" + " " * 2000 + "!"`.

`LOOSE_HTTP_DATE_RE` (used by `http2time`) has, right before the end of the
pattern, a timezone group followed by `\s*` and then an optional
`(\w+)`-in-parens group followed by another `\s*`. In the fixed version these
two `\s*` runs are nested one level further in so that, when the trailing
text is just spaces, there's only one way to divide it between them. The
injected bug flattens the nesting back to the pre-fix form, reintroducing two
independent, overlapping `\s*` groups that can each consume a run of spaces
in exponentially many ways (catastrophic backtracking).

- `python-clean` (fixed regex): `http2time` fails to match the string (it
  isn't a valid date) and returns `None` almost instantly.
- `python-buggy` (`injection.patch` applied): the same call makes the regex
  engine backtrack exponentially over the 2000 spaces and the process hangs
  indefinitely (never completes; confirmed to exceed a 10s timeout, where
  `python-clean` takes a few milliseconds).
