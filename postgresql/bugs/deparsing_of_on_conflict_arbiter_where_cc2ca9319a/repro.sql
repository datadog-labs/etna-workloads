create table hat_data(hat_name text, hat_color text);
create unique index on hat_data(hat_name) where hat_color = 'green';
create view hats as select * from hat_data;
create rule hat_nosert as on insert to hats do instead
  insert into hat_data values (new.hat_name, new.hat_color)
  on conflict (hat_name) where hat_color = 'green' do nothing returning *;
select definition from pg_rules where tablename='hats';
