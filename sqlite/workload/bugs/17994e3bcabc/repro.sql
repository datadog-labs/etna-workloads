CREATE TABLE f1(a, b, c);
CREATE INDEX f1ab ON f1(a, b);
SELECT * FROM f1 WHERE (?, ? COLLATE nose) > (a, b);
