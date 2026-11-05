\startpipeline
COPY (SELECT 1) TO STDOUT;
\syncpipeline
\endpipeline
\echo done
