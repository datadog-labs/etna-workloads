create table brtrigpartcon (a int, b text) partition by list (a);
create table brtrigpartcon1 partition of brtrigpartcon for values in (1);
create function brtrigpartcon1trigf() returns trigger as $$begin new.a := 2; return new; end$$ language plpgsql;
create trigger brtrigpartcon1trig before insert on brtrigpartcon1 for each row execute procedure brtrigpartcon1trigf();
insert into brtrigpartcon values (1, 'hi there');
select * from brtrigpartcon1;
