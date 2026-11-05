create table t(key int4, fruit text);
create view v as select * from t;
create unique index ie on t(lower(fruit));
explain (costs off) insert into v values(0,'x') on conflict (lower(fruit)) do nothing;
create unique index pi on t(key) where fruit like '%berry';
insert into v values (23,'Blackberry') on conflict (key) where fruit like '%berry' do nothing;
