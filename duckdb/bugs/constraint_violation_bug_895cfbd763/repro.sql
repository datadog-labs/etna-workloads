.mode list
.nullvalue NULL
CREATE TABLE B (b1 INTEGER,
b2 INTEGER,
PRIMARY KEY(b1, b2));
CREATE TABLE A (a1 VARCHAR(1),
a2 VARCHAR(1),
a3 VARCHAR(1),
a4 VARCHAR(1),
a5 INTEGER,
a6 INTEGER,
PRIMARY KEY(a1, a2),
UNIQUE(a3, a4),
FOREIGN KEY (a5, a6) REFERENCES B(b1, b2));
INSERT INTO B (b1, b2) VALUES
(1, 2),
(2, 3),
(6, 7);
INSERT INTO A (a1, a2, a3, a4, a5, a6) VALUES
('x', 'y', 'z', 'u', 1, 2),
('y', 'z', 'x', 'v', 1, 2),
('x', 'x', 'y', 'y', 2, 3),
('z', 'z', 'v', 'x', 4, 5);
