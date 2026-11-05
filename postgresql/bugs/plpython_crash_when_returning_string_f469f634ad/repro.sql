CREATE EXTENSION plpython3u;
CREATE FUNCTION r(first text, second int) RETURNS record AS $$
return "('%s',%r)" % (first, second)
$$ LANGUAGE plpython3u;
SELECT * FROM r('one', 1) AS f(first text, second int);
