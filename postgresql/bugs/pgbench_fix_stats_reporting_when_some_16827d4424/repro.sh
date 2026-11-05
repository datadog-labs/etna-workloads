pgbench -n -t 1 -R 1000 -L 100000 -f /dev/stdin postgres 2>&1 <<'Q' | grep 'above the'
select 1;
Q
