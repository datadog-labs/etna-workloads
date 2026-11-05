psql -X -q -c "create table accounts(accountid text, balance int); insert into accounts values ('checking',600),('savings',600);"
psql -X -q <<'S1' &
begin;
update accounts set balance = balance + 450 where accountid='checking';
select pg_sleep(2);
commit;
S1
sleep 1
psql -X -A -c "select * from accounts a1, accounts a2 where a1.accountid=a2.accountid for update of a1;"
wait
