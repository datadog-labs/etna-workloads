create function f1() returns int
begin atomic
select 1;
\if false
begin
\endif
select 2;
end;
\echo done
select f1();
select 'next';
