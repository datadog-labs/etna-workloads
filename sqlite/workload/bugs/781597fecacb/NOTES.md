repro.sh creates a database, sets the file format write version (header byte 18) to 3, then opens it and runs `.databases`, which uses sqlite3_db_readonly() to print "r/o" or "r/w".
Clean shell reports `r/o`; the buggy shell checks only the pager's readonly flag and reports `r/w`.
