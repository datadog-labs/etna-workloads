\startpipeline
COPY (select 1) TO STDOUT;
SELECT 'val1';
\endpipeline
\echo done
