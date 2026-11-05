copy nonexistent_tbl from stdin;
select 'injected' as executed;
\.
select 'done' as fin;
