.mode list
.nullvalue NULL
SET debug_verify_statement='explain_sql';
EXPLAIN (SQL) SELECT union_tag(u),union_extract(u,'v'),union_extract(u,'v')='a',u IS NULL FROM (SELECT union_value(v := 'A' COLLATE NOCASE) u);
