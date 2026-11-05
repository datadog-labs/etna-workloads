create table hat_data(hat_name char(10), hat_color char(10));
create unique index hu on hat_data (hat_name);
create table hats(hat_name char(10), hat_color char(10));
create rule r as on insert to hats do instead insert into hat_data values (new.hat_name,new.hat_color) on conflict (hat_name) do nothing;
select definition from pg_rules where tablename='hats';
