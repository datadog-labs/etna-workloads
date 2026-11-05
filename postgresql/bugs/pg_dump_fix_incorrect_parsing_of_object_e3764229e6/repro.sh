printf 'exclude table-data one\n' > filter.txt
pg_dump --filter=filter.txt postgres >/dev/null 2>err.txt
echo "exit=$?"
cat err.txt | sed 's/^[^:]*: //' 
rm -f filter.txt err.txt
