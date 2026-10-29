repro.sql runs the subtype1-300 and subtype1-320 queries. Subtypes must not cross a
subquery boundary. The buggy shell lets the JSON subtype leak through a pushed-down
constraint's soft-collate wrapper, so json_quote() sees a JSON value.
Clean output: `1` and `1|"1"`. Buggy output differs (see ./check.sh).
