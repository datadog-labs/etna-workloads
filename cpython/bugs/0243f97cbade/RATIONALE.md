# Rationale

Most of the fix (locatetagend, new parse_endtag, attrfind) is already in v3.15.2
and is covered by later code, so only one hunk is reverted.

## Lib/html/parser.py, `set_cdata_mode`
Reverses the fix hunk that changed
`re.compile(r'</\s*%s\s*>' % elem, re.I)` to
`r'</%s(?=[\t\n\r\f />])'` with `re.IGNORECASE|re.ASCII`. I restored the old
pattern in both the escapable and non-escapable branches (the v3.15.2 code
has since split them, but each is the same regex the fix replaced).

Effect: whitespace is accepted between `</` and the tag name, `\s` matches
`\v`/non-ASCII whitespace, and an end tag with attributes or a trailing `/`
(`</script foo=bar>`, `</script/>`) no longer closes the script/style element.
`</ script>` ends the CDATA section again.

## Oracle failures
`./check.sh` reports 6 of 66 oracle cases failing: test_closing_tag,
test_eof_in_script, test_eof_in_title, test_invalid_closing_tag,
test_invalid_nonascii_closing_tag and test_script_closing_tag. For example,
`</script foo=">">` no longer closes the script element, and the EOF cases
with partial end tags (`</script foo=bar`) are handled differently.
