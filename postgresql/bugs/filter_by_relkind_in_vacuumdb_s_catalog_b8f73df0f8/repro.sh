psql -X -q -c "CREATE VIEW vacview AS SELECT 1 AS a" postgres
vacuumdb --analyze --table vacview postgres 2>&1
echo "exit $?"
