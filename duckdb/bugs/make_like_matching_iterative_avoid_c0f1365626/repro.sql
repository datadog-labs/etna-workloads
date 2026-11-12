.mode list
.nullvalue NULL
SELECT like_escape(repeat('a', 30000), repeat('%a', 30000), '');
SELECT like_escape(repeat('a', 29999), repeat('%a', 30000), '');
SELECT repeat('a', 30000) LIKE repeat('%a', 30000);
SELECT ilike_escape(repeat('A', 30000) || 'b', repeat('%a', 30000) || '%c', '');
SELECT like_escape(repeat('ab', 1000), repeat('%a_', 1000) || '%', '\');
SELECT like_escape('x%y%z', '%\%%\%%', '\');
SELECT like_escape('x%y%z', '%\%%\%%\%%', '\');
