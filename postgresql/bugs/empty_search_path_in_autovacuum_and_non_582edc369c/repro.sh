psql -X -q -c "create schema s" -c "create table s.t(a int primary key)" -c "cluster s.t using t_pkey" -c "alter database postgres set search_path = s"
clusterdb -e -t t 2>&1
reindexdb -e -t t 2>&1
reindexdb -e -i t_pkey 2>&1
echo done
