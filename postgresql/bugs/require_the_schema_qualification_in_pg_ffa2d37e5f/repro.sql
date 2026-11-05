create domain pg_temp.nonempty as text check (value <> '');
select nonempty('');
select pg_temp.nonempty('');
