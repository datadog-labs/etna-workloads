CREATE EXTENSION plpython3u;
CREATE FUNCTION python_error_detail() RETURNS SETOF text AS $$
  plan = plpy.prepare("SELECT to_date('xy', 'DD') d")
  for row in plpy.cursor(plan):
    yield row['d']
$$ LANGUAGE plpython3u;
SELECT python_error_detail();
