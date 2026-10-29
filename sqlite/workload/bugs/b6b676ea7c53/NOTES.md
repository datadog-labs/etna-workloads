repro.sql: FK ON DELETE CASCADE with table/column names containing escaped double quotes ("""1").
Clean shell prints only "1|abc" and exits 0. Buggy shell prints "1|abc", then aborts on the DELETE
with assertion `z[i]' failed in sqlite3Dequote (the generated cascade trigger de-quotes names twice).
