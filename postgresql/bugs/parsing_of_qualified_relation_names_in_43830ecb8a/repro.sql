CREATE TABLE public.tt(a int, b int);
INSERT INTO public.tt VALUES (1, 10);
DO $$ BEGIN
  PERFORM 1;
  EXECUTE 'UPDATE public.tt SET b = b * 2 RETURNING a, b, old.b, new.b, tt.b, public.tt.b';
  RAISE NOTICE 'ok';
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'failed'; END $$;
DROP TABLE public.tt;
