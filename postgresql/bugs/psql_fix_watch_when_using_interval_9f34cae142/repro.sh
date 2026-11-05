echo 'select 1 \watch c=3 i=0.0001' | timeout 5 psql -X -q >/dev/null 2>&1
echo "exit=$?"
