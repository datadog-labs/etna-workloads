create type jpop2 as (a int, b json, c int, d int);
select * from json_populate_recordset(null::jpop2, '[{"a":2,"c":3,"b":{"z":4},"d":6}]') q;
select * from json_to_recordset('[{"a":1,"b":{"d":"foo"},"c":true},{"a":2,"c":false,"b":{"d":"bar"}}]') as x(a int, b json, c boolean);
