PRAGMA foreign_keys=ON;
CREATE TABLE """1"("""2" TEXT PRIMARY KEY, """3" TEXT);
INSERT INTO """1"("""2","""3") VALUES('abc','def');
CREATE TABLE """4"("""5" TEXT REFERENCES """1" ON DELETE CASCADE);
INSERT INTO """4"("""5") VALUES('abc');
INSERT INTO """1"("""2","""3") VALUES('uvw','xyz');
SELECT 1, """5" FROM """4";
DELETE FROM """1";
SELECT 2, """5" FROM """4";
