# Rationale

v3.15.2 already contains the generic `find_prefix_id`/`derived_name_prefixes` machinery from the fix, so the fix's C hunks can't be reversed. The bug (gh-80667) is that Tangut ideograph names were unsupported in unicodedata (name() returned no name, lookup() raised KeyError).

Change: in `Modules/unicodename_db.h`, removed the two Tangut rows from `derived_name_ranges`
(`{0x17000, 0x187FF, 2}` and `{0x18D00, 0x18D1E, 2}`). This reverses the fix hunk that added those rows (generated from makeunicodedata.py's "Tangut Ideograph" entry in `derived_name_range_names`). Without the rows, `_getucname` and `_getcode` fall through to the DAWG, which has no Tangut names, as before the fix.

Failing oracle: `test_unicodedata.UnicodeFunctionsTest.test_name`
(`name('\U00017000', None)` is None instead of 'TANGUT IDEOGRAPH-17000'). Tangut cases in test_ucn (test_tangut_ideographs) should fail via lookup as well.
