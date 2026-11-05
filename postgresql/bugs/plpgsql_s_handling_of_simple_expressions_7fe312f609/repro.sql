do $$
declare
 p_CurData refcursor;
 val int;
begin
 open p_CurData scroll for select 42;
 fetch p_CurData into val;
 raise notice 'val = %', val;
end; $$;
