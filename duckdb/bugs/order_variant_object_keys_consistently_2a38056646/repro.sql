.mode list
.nullvalue NULL
select '"test"'::JSON::VARIANT;
select ['"test"'::JSON for _ in range(10)]::JSON::VARIANT;
select '{"hello": [1,2,true, false, null], "test": [1, {"test": false}, ["blob", "this is a long string", 123]]}'::JSON::VARIANT;
WITH src(j) AS (
    VALUES ('{"n":123456789012345678901234567890}'::JSON)
)
SELECT
    (j::VARIANT).n as value, variant_typeof(value) as variant_type
FROM src;
SELECT (v).a, variant_keys(v), v::JSON
FROM (SELECT '{"a":1,"a":2}'::JSON::VARIANT AS v);
SELECT (v.outer).a, variant_keys(v, 'outer'), v::JSON
FROM (SELECT '{"outer":{"a":1,"b":2,"a":3}}'::JSON::VARIANT AS v);
SELECT (v).a, variant_keys(v), v::JSON
FROM (
	VALUES
		('{"a":null,"a":[1,2]}'::JSON::VARIANT),
		('{"a":[1,2],"a":null}'::JSON::VARIANT)
) t(v);
SELECT (v).a, variant_keys(v)
FROM (
	SELECT j::VARIANT AS v
	FROM (VALUES ('{"a":1,"a":2}'::JSON), ('{"a":3,"b":4,"a":5}'::JSON)) t(j)
);
select '"test"'::JSON::VARIANT::JSON;
select ['"test"' for _ in range(10)]::JSON::VARIANT::JSON;
select '{"hello": [1,2,true, false, null], "test": [1, {"test": false}, ["blob", "this is a long string", 123]]}'::JSON::VARIANT::JSON;
select '{"hello": [1,2,true, false, null], "test": [1, {"test": false}, ["blob", "this is a long string", 123]]}'::JSON::VARIANT::JSON from range(10);
SELECT 0.5::DECIMAL(1,1)::VARIANT::JSON, (-0.5::DECIMAL(1,1))::VARIANT::JSON;
SELECT 0.5::DECIMAL(4,4)::VARIANT::JSON,
       0.5::DECIMAL(9,9)::VARIANT::JSON,
       0.5::DECIMAL(18,18)::VARIANT::JSON,
       0.5::DECIMAL(38,38)::VARIANT::JSON;
SELECT [0.5::DECIMAL(1,1), -0.5::DECIMAL(1,1)]::VARIANT::JSON;
SELECT {'positive': 0.5::DECIMAL(1,1), 'negative': -0.5::DECIMAL(1,1)}::VARIANT::JSON;
SELECT json_valid(0.5::DECIMAL(1,1)::VARIANT::JSON),
       json_valid([0.5::DECIMAL(1,1)]::VARIANT::JSON),
       json_valid({'value': -0.5::DECIMAL(1,1)}::VARIANT::JSON);
create table tbl(var JSON);
insert into tbl select '{"test":123,"hello":[1,2,3],"world":{"test":true}}';
insert into tbl select '{"test":123,"hello":[4,5,6],"world":{"test":true}}';
insert into tbl select '{"test":123,"hello":[],"world":{"test":true}}';
select var::VARIANT from tbl;
