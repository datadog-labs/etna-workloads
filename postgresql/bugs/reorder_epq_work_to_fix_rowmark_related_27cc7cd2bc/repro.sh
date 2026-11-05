psql -X -q -c "create table accounts(accountid text primary key, balance numeric, balance2 numeric generated always as (balance*2) stored); insert into accounts values('checking',600),('savings',600)"
( psql -X -q -c "begin; update accounts set balance=balance+450 where accountid='checking'; select pg_sleep(3); commit" >/dev/null ) &
sleep 1
psql -X -a -q -c "SELECT a1.*, v.id FROM accounts a1, (values('checking'::text,'nan'::text),('savings','nan')) v(id,notnumeric) WHERE a1.accountid=v.id AND v.notnumeric != 'einszwei' ORDER BY 1 FOR UPDATE OF a1" 2>&1
wait
