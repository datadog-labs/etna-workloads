create table t(id int, name varchar) as values (1,'foo'),(2,'bar');
SELECT to_timestamp(123.5, name) FROM t ORDER BY id;
SELECT to_timestamp(456.789::float, name) FROM t ORDER BY id;
SELECT to_timestamp(arrow_cast(100.5, 'Float16'), name) FROM t ORDER BY id;
