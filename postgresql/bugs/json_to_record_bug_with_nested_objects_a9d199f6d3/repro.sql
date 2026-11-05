select *, c is null as c_is_null
from json_to_record('{"a":1, "b":{"c":16, "d":2}, "x":8}'::json)
    as t(a int, b json, c text, x int);
select js from json_populate_record(NULL::record, '{"js": {"a": 1}}') as q(js json);
