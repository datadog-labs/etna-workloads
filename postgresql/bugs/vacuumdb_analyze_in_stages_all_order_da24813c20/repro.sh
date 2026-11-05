psql -X -q -c "create database d2" postgres
vacuumdb --analyze-in-stages --all 2>&1 | grep Generating
