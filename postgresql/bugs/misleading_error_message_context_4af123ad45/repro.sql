do $$ begin raise notice '%', 1/0; end $$;
do $$ begin perform 1/0; end $$;
do $$ begin return; end $$;
do $$ declare x int := 1/0; begin end $$;
