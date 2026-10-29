CREATE VIRTUAL TABLE "My.Table" USING fts5(Text);
INSERT INTO "My.Table" VALUES ('rank on an fts5 table');
INSERT INTO "My.Table" VALUES ('table table table');
SELECT * FROM "My.Table" WHERE Text MATCH 'table' ORDER BY rank;
