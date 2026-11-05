psql -X -q -c "CREATE TABLE accounts (accountid text PRIMARY KEY, balance numeric not null); INSERT INTO accounts VALUES ('checking',600),('savings',600);
CREATE FUNCTION update_checking(int) RETURNS bool LANGUAGE sql AS \$\$ UPDATE accounts SET balance = balance + 1 WHERE accountid = 'checking'; SELECT true;\$\$;"
run() {
  ( echo "BEGIN; UPDATE accounts SET balance = balance - 200 WHERE accountid = 'checking';"; sleep 3; echo "COMMIT;" ) | psql -X -q >/dev/null 2>&1 &
  sleep 1
  psql -X -q -c "$1" 2>&1
  wait
  psql -X -q -c "SELECT * FROM accounts ORDER BY 1"
  psql -X -q -c "UPDATE accounts SET balance=600"
}
run "WITH doup AS (UPDATE accounts SET balance = balance + 1100 WHERE accountid = 'checking' RETURNING *, update_checking(999)) DELETE FROM accounts a USING doup RETURNING *"
run "WITH doup AS (UPDATE accounts SET balance = balance + 1100 WHERE accountid = 'checking' RETURNING *) UPDATE accounts a SET balance = doup.balance + 100 FROM doup RETURNING *"
