CREATE EXTENSION plpython3u;
CREATE FUNCTION notice_innerfunc() RETURNS int AS $$
plpy.execute("DO LANGUAGE plpython3u $x$ plpy.notice('inside DO') $x$")
return 1
$$ LANGUAGE plpython3u;
CREATE FUNCTION notice_outerfunc() RETURNS int AS $$
plpy.execute("SELECT notice_innerfunc()")
return 1
$$ LANGUAGE plpython3u;
\set SHOW_CONTEXT always
SELECT notice_outerfunc();
