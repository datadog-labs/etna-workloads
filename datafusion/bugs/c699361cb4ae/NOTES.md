Creates a table with a varchar separator column, then calls concat_ws with the separator cast to Utf8View and LargeUtf8 (array separators).
Clean build returns `a|b` / `foo,bar`. Buggy build errors, because array separators are required to be Utf8.
