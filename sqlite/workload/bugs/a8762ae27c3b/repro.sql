CREATE TABLE blob(rid INTEGER PRIMARY KEY, uuid TEXT, CHECK( length(uuid)>=40 AND rid>0 ));
ALTER TABLE "blob" RENAME COLUMN "rid" TO "a1";
SELECT sql FROM sqlite_master;
