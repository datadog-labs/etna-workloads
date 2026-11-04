SELECT column1, column2, COUNT(*) FROM (
VALUES
  ('x', arrow_cast('NAN','Float64')),
  ('x', arrow_cast('NAN','Float64')),
  ('x', arrow_cast('NAN','Float64'))
) GROUP BY 1, 2 ORDER BY 1;
