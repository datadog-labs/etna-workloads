.mode list
.nullvalue NULL
SET debug_verify_statement='explain_sql';
EXPLAIN (SQL) SELECT i,CASE WHEN i=4 THEN NULL ELSE struct_pack(v := s COLLATE NOCASE) END v FROM (VALUES (0,'A'),(1,'a'),(2,'B'),(3,NULL),(4,'A')) t(i,s) ORDER BY i;
