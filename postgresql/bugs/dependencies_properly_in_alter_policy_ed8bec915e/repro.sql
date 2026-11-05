CREATE ROLE rb;
CREATE TABLE d1(a int);
CREATE TABLE d2(a int);
CREATE POLICY p1 ON d1 TO rb USING (a IN (SELECT a FROM d2));
ALTER POLICY p1 ON d1 WITH CHECK (true);
SELECT count(*) FROM pg_depend WHERE classid='pg_policy'::regclass AND refobjid='d2'::regclass;
SELECT count(*) FROM pg_depend WHERE classid='pg_policy'::regclass AND refobjid='rb'::regclass;
ALTER POLICY p1 ON d1 USING (true);
SELECT count(*) FROM pg_shdepend WHERE refobjid='rb'::regrole;
