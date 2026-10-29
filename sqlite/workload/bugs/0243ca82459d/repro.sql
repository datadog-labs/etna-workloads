CREATE TABLE items (
  Id INTEGER, Item INTEGER, Test TEXT, Filler,
  PRIMARY KEY(Id), UNIQUE(Item, Id)
);
INSERT INTO items (Id, Item) VALUES (1, 2), (2, 2), (3, 3), (4, 5);
UPDATE items SET test='ok' WHERE (Id, Item) IN (SELECT Id, Item FROM items);
SELECT Id, Item, test FROM items ORDER BY id;
