CREATE TABLE no_ri (a int, b int);
CREATE TABLE pk (a int primary key, b int);
SET client_min_messages = 'ERROR';
CREATE PUBLICATION pub1 FOR ALL TABLES;
RESET client_min_messages;
MERGE INTO no_ri USING pk s ON s.a >= 1 WHEN MATCHED THEN UPDATE SET b = s.b;
MERGE INTO no_ri USING pk s ON s.a >= 1 WHEN MATCHED THEN DELETE;
DROP PUBLICATION pub1;
