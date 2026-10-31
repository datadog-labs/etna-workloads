# Rationale

Fix: gh-69426, HTMLParser only unescapes properly terminated character
entities in attribute values.

## Change
`Lib/html/parser.py`, `parse_starttag`: `attrvalue = _unescape_attrvalue(attrvalue)`
is changed back to `attrvalue = unescape(attrvalue)`.

This reverses the fix hunk that replaced `unescape(attrvalue)` with
`_unescape_attrvalue(attrvalue)`. The helpers (`attr_charref`,
`_replace_attr_charref`, `_unescape_attrvalue`) are left in place but unused,
as they were the fix's additions. Without them in the call path, attribute
values go through the full `html.unescape`, which also decodes unterminated
named entities followed by an alphanumeric or `=`.

## Oracle failures
`HTMLParserTestCase.test_convert_charrefs_in_attribute_values` fails.
`&centz` and `&cent=z` in attribute values are unescaped to `¢z` and `¢=z`
instead of staying as `&centz` and `&cent=z`.
