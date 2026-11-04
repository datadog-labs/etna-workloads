CREATE TABLE dict_test_base(col1 TEXT, col2 TEXT) AS VALUES ('foo','bar'),('bar','bar'),('baz','bar');
SELECT NULLIF(arrow_cast(col1, 'Dictionary(Int32, Utf8)'), 'bar') AS r FROM dict_test_base ORDER BY r;
SELECT NULLIF(col2, arrow_cast(col1, 'Dictionary(Int32, Utf8)')) AS r FROM dict_test_base ORDER BY r;
SELECT NULLIF(arrow_cast(col1, 'Dictionary(Int32, Utf8)'), arrow_cast('bar', 'Dictionary(Int32, Utf8)')) AS r FROM dict_test_base ORDER BY r;
