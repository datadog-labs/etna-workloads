# Rationale

File: src/bin/scripts/vacuumdb.c, function vacuum_all_databases().
Traces to the fix.patch hunk in vacuum_all_databases() that made the stage loop the outer loop and the database loop the inner loop.
I swapped the nesting back. The loop over databases is now outer and the loop over stages is inner. With `--analyze-in-stages --all`, each database now goes through all three stages before the next database starts. The correct order runs stage 1 on every database, then stage 2, then stage 3. The wrong order means the minimal stats are not available everywhere quickly.

Failing oracle case (verified): src/bin/scripts|t/102_vacuumdb_stages.pl|analyze more than one database in stages: SQL found in server log. The other three cases pass.
