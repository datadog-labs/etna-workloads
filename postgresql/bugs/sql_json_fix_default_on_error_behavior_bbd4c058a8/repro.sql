CREATE VIEW jv8 AS SELECT * from JSON_TABLE('"a"', '$' COLUMNS (a text PATH '$') EMPTY ON ERROR);
\sv jv8
CREATE VIEW jv9 AS SELECT * from JSON_TABLE('"a"', '$' COLUMNS (a text PATH '$') EMPTY ARRAY ON ERROR);
\sv jv9
