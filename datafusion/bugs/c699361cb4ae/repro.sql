create table test_concat_ws_sep (sep varchar, val1 varchar, val2 varchar) as values (',', 'foo', 'bar'), ('|', 'a', 'b');
SELECT concat_ws(arrow_cast(sep, 'Utf8View'), val1, val2) FROM test_concat_ws_sep ORDER BY val1;
SELECT concat_ws(arrow_cast(sep, 'LargeUtf8'), val1, val2) FROM test_concat_ws_sep ORDER BY val1;
