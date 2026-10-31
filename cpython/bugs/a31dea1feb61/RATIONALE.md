# Rationale

Fix reverted (gh-106669): the strict getaddresses validation miscounted commas
inside quoted real names, so `'"Bud, Person" <bperson@dom.ain>'` yielded `[('', '')]`.
In v3.15.2 the later fix is `_strip_quoted_realnames(v)` before counting commas in
`getaddresses` (Lib/email/utils.py). I removed that call (and its comment), so the
expected-address count `n` is once again `1 + v.count(',')` including commas in
quoted names. This reproduces the original defect (comma in quoted name
makes `len(result) != n`).

Failing oracle cases: 3 in test_email.test_email (quoted-comma getaddresses
tests, which now return `[('', '')]`).
