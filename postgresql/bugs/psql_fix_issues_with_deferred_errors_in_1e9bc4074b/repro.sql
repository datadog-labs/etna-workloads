CREATE TABLE d(a int PRIMARY KEY DEFERRABLE INITIALLY DEFERRED);
\startpipeline
INSERT INTO d VALUES ($1), ($1) \bind 1 \sendpipeline
\syncpipeline
SELECT $1 \bind 'after_sync_1' \sendpipeline
\endpipeline
SELECT 'done';
