CREATE EXTENSION plpython3u;
CREATE FUNCTION f() RETURNS text[] AS $$
return [[], []]
$$ LANGUAGE plpython3u;
select f();
