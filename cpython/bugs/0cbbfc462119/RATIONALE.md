# Rationale

Changed `Lib/html/parser.py`, `HTMLParser.parse_html_declaration`: the
`<![CDATA[` branch (guarded by `_support_cdata`) once again calls
`self.parse_marked_section(i)` instead of searching for the literal `]]>`.
This reverses the fix hunk that replaced `parse_marked_section(i)` with
`rawdata.find(']]>', i+9)` + `unknown_decl(...)`. `parse_marked_section`
(from `_markupbase`) ends the section with the regex `]\s*]\s*>`, so
`] ]>` and `]] >` end the CDATA section, the pre-fix behaviour.

The flag/`_set_support_cdata` plumbing and the EOF handling in `goahead` are
left in place (they are unchanged parts of the fix that don't cause the bug).

Failing oracle cases: `test_cdata_section_content` (the `] ]>` and `]] >`
subtests: the section ends early, leaving `]]>` as data) — 2 failures.
