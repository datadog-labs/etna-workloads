create view rule_v1(x) as values(1,2);
select pg_get_viewdef('rule_v1'::regclass);
