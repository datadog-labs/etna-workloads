rm -f t.db
"$SQLITE3" t.db <<'S'
CREATE TABLE gigo(a text);
CREATE TABLE idx(x text COLLATE nocase);
CREATE VIEW v1 AS SELECT * FROM idx WHERE x='abc';
.dbconfig defensive off
PRAGMA writable_schema=1;
UPDATE sqlite_master SET sql=replace(sql,'nocase','nosuchcoll') WHERE name='idx';
S
"$SQLITE3" t.db <<'S'
alter table gigo rename to ggiiggoo;
alter table idx rename to idx2;
ALTER TABLE idx2 RENAME x TO y;
SELECT sql FROM sqlite_master;
S
echo "exit=$?"
