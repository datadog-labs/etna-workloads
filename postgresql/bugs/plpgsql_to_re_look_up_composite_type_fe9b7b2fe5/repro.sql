set check_function_bodies = off;
create function sillyaddtwo(int) returns int language plpgsql as
$$ declare r mutable2; begin r.f1 := $1; return r.f1 + 2; end $$;
reset check_function_bodies;
create table mutable2(f1 int, f2 text);
select sillyaddtwo(42);
drop table mutable2;
select sillyaddtwo(42);
create table mutable2(f0 text, f1 int, f2 text);
select sillyaddtwo(42);
