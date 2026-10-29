CREATE TABLE "Test" (
  "IsActive" INTEGER,
  CONSTRAINT "BooleanZeroOrOne" CHECK ("IsActive" IN (0, 1))
);
ALTER TABLE Test DROP CONSTRAINT "BooleanZeroOrOne";
SELECT sql FROM sqlite_schema;
