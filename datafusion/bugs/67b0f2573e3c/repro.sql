CREATE TABLE table1(v1 STRING) AS VALUES ('foo'), (NULL);
CREATE TABLE table1_stringview AS SELECT arrow_cast(v1, 'Utf8View') AS v1 FROM table1;
select * from table1 as t1 natural join table1_stringview as t2;
