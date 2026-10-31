# Rationale

Fix hunk reversed: `parse_html_declaration` in `Lib/html/parser.py` dispatching
`<![CDATA[` (the fix changed `rawdata[i:i+3] == '<!['` to `rawdata[i:i+9] == '<![CDATA['`).

In v3.15.2 that branch had been rewritten inline (`<![CDATA[` and `_support_cdata`).
I restored the pre-fix dispatch: any `<![` goes to `parse_marked_section`
(from `_markupbase`), so non-CDATA declarations such as `<![if !IE]>` become
`unknown decl` instead of bogus comments, and `<![CDATA[` goes through the
marked-section scanner. The `parse_bogus_comment` assertion-message hunk is
cosmetic and was not reverted.

Oracle: 5 test_htmlparser cases fail (e.g. test_broken_condcoms, test_bogus_comments,
CDATA tests), showing unknown-decl / wrong CDATA handling instead of bogus comments.
