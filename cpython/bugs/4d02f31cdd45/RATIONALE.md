# Rationale

Fix (gh-118350) made `textarea` and `title` escapable-raw-text elements in
`html.parser.HTMLParser`. Its key hunk in `parse_starttag` added
`elif tag in self.RCDATA_CONTENT_ELEMENTS: self.set_cdata_mode(tag, escapable=True)`.

In v3.15.2 the surrounding code was rewritten (more CDATA elements, scripting,
plaintext) so a literal reverse does not apply. I removed that same `elif`
branch in `Lib/html/parser.py::parse_starttag`, so `<textarea>`/`<title>` no
longer enter RCDATA mode and their content is parsed as normal markup (the
pre-fix behaviour). The rest of the fix (`_escapable`, `set_cdata_mode`
signature) is left in place; it is simply never used with `escapable=True`.

Failing oracle cases: `test_title_content`, `test_textarea_content`,
`test_title_closing_tag`, `test_textarea_closing_tag`, `test_eof_in_title`
subtests (15 failures): tags/comments inside title/textarea are reported as
starttag/comment events instead of a single data event.
