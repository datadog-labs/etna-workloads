# Configure a page cache with a 1KB bulk allocation (-pagecache 0 -1), then
# use a 4096-byte page size so a single page does not fit in the bulk block.
"$SQLITE3" -pagecache 0 -1 test.db "PRAGMA page_size=4096; CREATE TABLE t1(x);"
echo "exit=$?"
