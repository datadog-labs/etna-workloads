cat > nested_if.sql <<'EOS'
\if false
	SELECT 1 / 0;
	\if true
		SELECT 1 / 0;
	\endif
\endif
\if true
	SELECT 'correct';
\endif
EOS
pgbench -n -c 1 -t 1 -f nested_if.sql postgres 2>&1 | grep -E 'actually processed|division|aborted'
echo "exit: $?"
rm -f nested_if.sql
