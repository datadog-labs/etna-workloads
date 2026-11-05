mkdir -p rt && cd rt
pg_basebackup -D bk -X fetch -c fast
chmod 700 bk
cat >> bk/postgresql.conf <<EOC
port = 54399
unix_socket_directories = '$PWD'
restore_command = 'false'
recovery_target_name = 'does_not_exist'
EOC
touch bk/recovery.signal
pg_ctl -D bk -l bk.log -w -t 20 start >/dev/null 2>&1
if pg_ctl -D bk status >/dev/null 2>&1; then echo "server running (promoted)"; pg_ctl -D bk -m fast stop >/dev/null 2>&1; else echo "server not running"; fi
grep -o 'recovery ended before configured recovery target was reached' bk.log | sort -u
