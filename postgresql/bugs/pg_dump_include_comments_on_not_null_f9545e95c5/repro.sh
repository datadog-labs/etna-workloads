psql -X -q -c "create domain d1 as int constraint nn not null constraint ck check (value>0)" -c "comment on constraint nn on domain d1 is 'nn comment'" -c "comment on constraint ck on domain d1 is 'ck comment'"
pg_dump -s | grep -E "CREATE DOMAIN|COMMENT ON|CONSTRAINT"
