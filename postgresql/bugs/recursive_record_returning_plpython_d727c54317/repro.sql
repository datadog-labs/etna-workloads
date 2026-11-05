CREATE EXTENSION plpython3u;
CREATE FUNCTION return_record_3(t text) RETURNS record AS $$
if t == "text":
     plpy.execute("SELECT * FROM return_record_3('int') AS (a int)");
     return { "a": "x" }
elif t == "int":
     return { "a": 1 }
$$ LANGUAGE plpython3u;
SELECT * FROM return_record_3('text') AS (a text);
