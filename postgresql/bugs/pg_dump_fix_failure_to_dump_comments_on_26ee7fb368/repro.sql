create domain dpc as text constraint dpc_chk check (value <> 'x');
comment on constraint dpc_chk on domain dpc is 'check it';
create table tc (a int, constraint tc_chk check (a < 10));
comment on constraint tc_chk on tc is 'bounds';
\! pg_dump -s -d postgres | grep '^COMMENT ON CONSTRAINT'
