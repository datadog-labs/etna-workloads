create table set_cmp_self(id int, age int) as values (1, 20), (2, 30), (3, 40);

select id from set_cmp_self where age = any(select age from set_cmp_self) order by id;

select id from set_cmp_self where age <> all(select age from set_cmp_self) order by id;
