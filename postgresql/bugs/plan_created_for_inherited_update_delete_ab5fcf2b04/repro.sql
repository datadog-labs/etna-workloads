create table stmt_t (a int);
create table stmt_t1 () inherits (stmt_t);
create function un() returns trigger as $$
begin raise notice 'updating %', TG_TABLE_NAME; return null; end;
$$ language plpgsql;
create trigger bt before update on stmt_t execute procedure un();
update stmt_t set a = a where false returning a+1 as aa;
