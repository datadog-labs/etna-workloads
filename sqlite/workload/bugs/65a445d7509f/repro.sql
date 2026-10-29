WITH vx(a,b) AS (VALUES
  ('-0','+0'),
  ('-000.000','0'),
  ('1.2','1.2000')
)
SELECT *, '|' FROM vx
 WHERE decimal_cmp(a,b)!=0
    OR decimal_cmp(b,a)!=0;
