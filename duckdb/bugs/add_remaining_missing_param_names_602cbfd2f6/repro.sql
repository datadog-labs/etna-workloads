.mode list
.nullvalue NULL
SELECT * FROM duckdb_functions();
select function_name from duckdb_functions() where not internal order by 1;
CREATE MACRO add_default1(a := 3, b := 5) AS a + b;
CREATE MACRO add_default2(a, b := 5) AS a + b;
SELECT * FROM duckdb_functions();
SELECT * FROM duckdb_functions() WHERE function_type='table';
SELECT sqrt(4);
select distinct function_name from duckdb_functions() where function_name='sqrt';
select function_name from duckdb_functions() where not internal order by 1;
create macro my_range(x) as table from range(x);
select macro_definition from duckdb_functions() where function_name = 'my_range';
SELECT count(*) FROM duckdb_functions()
WHERE (function_type == 'window' OR function_type == 'scalar' or function_type == 'aggregate')
AND list_contains(parameters, 'col0');
