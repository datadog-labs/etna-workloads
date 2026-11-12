.mode list
.nullvalue NULL
SELECT CASE WHEN i % 3 = 0 THEN NULL ELSE [i]::INT[1] END FROM range(5) t(i);
