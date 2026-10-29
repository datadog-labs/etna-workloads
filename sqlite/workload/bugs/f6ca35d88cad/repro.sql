PRAGMA encoding = 'UTF-16be';
CREATE TABLE Example(word TEXT NOT NULL);
CREATE INDEX Example_word on Example(word);
INSERT INTO Example VALUES(char(0x307F));
SELECT count(*) FROM Example WHERE word GLOB 'み*';
