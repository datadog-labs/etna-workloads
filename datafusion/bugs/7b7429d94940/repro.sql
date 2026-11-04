SELECT replace('abc', '', 'x');
SELECT replace(arrow_cast('abc', 'Utf8View'), '', 'x');
SELECT replace(arrow_cast('abc', 'LargeUtf8'), '', 'x');
SELECT replace(arrow_cast('abc', 'Dictionary(Int32, Utf8)'), '', 'x');
