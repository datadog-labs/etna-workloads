repro.py folds an address list whose display name is a long quoted string containing specials (`<`, `(`) with max_line_length=40.

- clean: `'"Exfiltrator <spy@example.org> (unclosed\n comment?" <to@example.com>\n'` (quotes kept)
- buggy: quotes are dropped and the specials get RFC 2047 encoded, so the result is mangled: `'Exfiltrator =?utf-8?q?=3Cspy=40example?=\n ...'`

The injection removes the `bare-quoted-string` folding branch in `_refold_parse_tree`.

I ran both interpreters by hand because `./check.sh` failed with a bwrap error in this sandbox (missing `.claude/launch.json` path).
