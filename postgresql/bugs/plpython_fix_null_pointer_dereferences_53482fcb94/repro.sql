CREATE EXTENSION plpython3u;
CREATE FUNCTION f() RETURNS int[] LANGUAGE plpython3u AS $$
class S:
    def __len__(self): return 2
    def __getitem__(self, i): raise ValueError('boom')
return S()
$$;
SELECT f();
