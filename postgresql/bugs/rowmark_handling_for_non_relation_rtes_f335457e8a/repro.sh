psql -X -q -c "create table accounts(accountid text primary key, balance numeric not null, balance2 numeric generated always as (balance*2) stored)" -c "insert into accounts values ('checking',600),('savings',600)"
( printf 'begin;\nupdate accounts set balance = balance + 100;\nselect pg_sleep(3);\ncommit;\n' | psql -X -q -o /dev/null ) &
sleep 1
psql -X -q -c "MERGE INTO accounts USING (VALUES ('checking', 610), ('savings', 620)) v(accountid, balance) ON v.accountid = accounts.accountid WHEN MATCHED THEN UPDATE SET balance = v.balance WHEN NOT MATCHED THEN INSERT VALUES ('unmatched', -1)" 2>&1
wait
psql -X -c "select * from accounts order by accountid" 2>&1
