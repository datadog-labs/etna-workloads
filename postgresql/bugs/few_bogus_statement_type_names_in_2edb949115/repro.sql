\set VERBOSITY default
create function f() returns void as $$
begin
  execute 'select 1/0';
end$$ language plpgsql;
select f();
create function g() returns void as $$
begin
  get stacked diagnostics x = message_text;
end$$ language plpgsql;
select g();
