for mode in yes no; do
  "$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --loglevel verbose --hide-user-data-from-log $mode &
  until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
  exec 3<>/dev/tcp/127.0.0.1/$PORT
  printf '*3\r\n$3\r\nSET\r\n$1\r\nx\r\n$blabla\r\n' >&3
  sleep 0.5
  exec 3>&-
  echo "hide=$mode"
  grep -q "Query buffer: .*redacted" s.log && echo "redacted marker present"
  grep -q "Query buffer: .*blabla" s.log && echo "raw query buffer logged"
  "$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
  wait
  rm -f s.log
done
