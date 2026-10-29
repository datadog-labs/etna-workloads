"$SQLITE3" -batch -init /dev/null :memory: ".backup temp bak.db" ".print done"
echo "rc=$?"
