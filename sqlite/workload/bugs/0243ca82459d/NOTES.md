repro.sql: creates a table with INTEGER PRIMARY KEY Id and UNIQUE(Item, Id), then runs
UPDATE ... WHERE (Id, Item) IN (SELECT Id, Item FROM items) (rowvalue-34.1).
Clean shell updates all 4 rows (prints 1|2|ok ... 4|5|ok, exit 0). Buggy shell hits
assertion failure in removeUnindexableInClauseTerms (abort, exit -6), because the
redundant IN column match is no longer removed from the WhereLoop.
