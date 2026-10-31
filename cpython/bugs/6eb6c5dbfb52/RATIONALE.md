# Rationale

Bug: gh-135462, HTMLParser.goahead() at EOF handled unterminated constructs
with `find('>')`/`find('<')` rescans, which is quadratic on crafted input, and
emitted the junk as text instead of following HTML5 EOF rules.

Changes (all in `Lib/html/parser.py`, `goahead`):

1. `elif (i + 1) < n or end:` -> `elif (i + 1) < n:` reverses the fix hunk that
   added `or end` (a lone trailing `<` at EOF was not flushed as data).
2. The `if k < 0:` EOF block (starttagopen/endtagopen/comment/CDATA/doctype/PI
   auto-closing, `k = n`) is replaced by the pre-fix fallback: find next `>`
   (else next `<`, else i+1), and emit that slice as data. This reverses the
   large fix hunk. The v3.15.2 code uses `self._escapable` where the pre-fix code
   used `not self.cdata_elem`, so the equivalent current condition is kept.
   `endtagopen` stays defined (still used by parse_endtag).

Oracle: 14 of 68 tests in test_htmlparser fail, including
test_eof_in_comments, test_eof_in_declarations, test_starttag_junk_chars,
test_tolerant_parsing and test_bogus_comments (unclosed `<!--`, `<!`, `<a`,
`</a` come out as data instead of comments/decls/nothing).
