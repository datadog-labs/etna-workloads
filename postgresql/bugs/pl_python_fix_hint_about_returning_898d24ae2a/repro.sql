CREATE EXTENSION plpython3u;
CREATE TYPE comp AS (a text, b int);
CREATE FUNCTION f() RETURNS comp[] AS $$
return [['first', 1]]
$$ LANGUAGE plpython3u;
SELECT * FROM f();
