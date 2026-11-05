cat > $PWD/pb_script.sql <<'EOS'
\startpipeline
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT 1;
END;
\endpipeline
EOS
pgbench -n -M prepared -t 1 -f $PWD/pb_script.sql postgres 2>&1 | grep -E 'transactions actually|error|ERROR|serializable'
rm -f $PWD/pb_script.sql
