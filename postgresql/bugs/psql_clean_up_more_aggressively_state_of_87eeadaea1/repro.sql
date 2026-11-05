SELECT $1, $2 \parse stmt3
\bind_named stmt3
\bind_named
\g
SELECT 1;
