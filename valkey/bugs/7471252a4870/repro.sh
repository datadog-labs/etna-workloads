P=$PORT; R=$((PORT+1))
"$VALKEY_SERVER" --port $P --save "" --appendonly no --dir . --logfile p.log \
  --repl-diskless-sync yes --repl-diskless-sync-delay 0 --dual-channel-replication-enabled yes &
mkdir -p r; cd r
"$VALKEY_SERVER" --port $R --save "" --appendonly no --dir . --logfile r.log \
  --repl-diskless-sync yes --repl-diskless-load swapdb --dual-channel-replication-enabled yes &
cd ..
for p in $P $R; do until "$VALKEY_CLI" -p $p ping >/dev/null 2>&1; do sleep 0.1; done; done
for j in $(seq 1 100); do echo "set key$j $(printf 'x%.0s' $(seq 1 100))"; done | "$VALKEY_CLI" -p $P >/dev/null
"$VALKEY_CLI" -p $P config resetstat
"$VALKEY_CLI" -p $R replicaof 127.0.0.1 $P
for i in $(seq 1 100); do
  "$VALKEY_CLI" -p $P info replication | grep -q 'state=online' && break; sleep 0.1
done
sleep 1
b=$("$VALKEY_CLI" -p $P info stats | grep total_net_repl_output_bytes | tr -d '\r' | cut -d: -f2)
[ "$b" -gt 1000 ] && echo "repl bytes > 1000" || echo "repl bytes too low"
"$VALKEY_CLI" -p $R shutdown nosave; "$VALKEY_CLI" -p $P shutdown nosave
wait
