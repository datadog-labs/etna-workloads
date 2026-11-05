psql -X -q -c "create table ta(id int primary key, value text); insert into ta values (1,'x');"
( echo "begin; update ta set value=null where id=1;"; sleep 3; echo "commit;" ) | psql -X -q &
sleep 1
psql -X -q -c "update ta set value = coalesce(value, (select text 'newValue')) where id=1;" 2>&1
wait
psql -X -q -c "select * from ta;"
