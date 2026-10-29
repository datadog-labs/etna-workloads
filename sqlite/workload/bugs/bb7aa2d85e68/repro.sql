SELECT json_patch('[1,2,3]','{"x":null}');
SELECT json_patch('[1,2,3]','{"x":null,"y":1,"z":null}');
SELECT json_patch('{}','{"a":{"bb":{"ccc":null}}}');
