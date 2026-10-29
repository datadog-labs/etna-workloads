repro.sh: opens a file DB, sets journal_mode=persist, turns on SQLITE_DBCONFIG_DEFENSIVE
(`.dbconfig defensive on`), then runs `PRAGMA journal_mode=off`.
Clean shell prints `persist` (OFF refused, mode unchanged); buggy shell prints `off`.
