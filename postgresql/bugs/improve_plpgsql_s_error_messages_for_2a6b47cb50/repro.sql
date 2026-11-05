\set VERBOSITY terse
do $$ declare x foo%type; begin end $$;
do $$ declare x foo.bar%type; begin end $$;
do $$ declare x foo.bar.baz%rowtype; begin end $$;
