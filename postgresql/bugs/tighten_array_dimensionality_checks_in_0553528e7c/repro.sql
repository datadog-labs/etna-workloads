CREATE EXTENSION plpython3u;
CREATE FUNCTION f1() RETURNS text[] AS $$ return [[1,2,3], "abc"] $$ LANGUAGE plpython3u;
SELECT f1();
CREATE FUNCTION f2() RETURNS text[] AS $$ return ["abc", [1,2,3]] $$ LANGUAGE plpython3u;
SELECT f2();
CREATE FUNCTION f3() RETURNS text[] AS $$ return [[], [1]] $$ LANGUAGE plpython3u;
SELECT f3();
CREATE FUNCTION f4() RETURNS int[] AS $$ return [[1,2,3],[4,5]] $$ LANGUAGE plpython3u;
SELECT f4();
