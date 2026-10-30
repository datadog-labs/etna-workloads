"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
args=""
for i in $(seq 0 1999); do args="$args PREFIX PREFIX-$i-$i-$i-$i-$i-$i-$i"; done
getmem() { sed -n 's/.*tot-mem=\([0-9]*\).*/\1/p'; }
{
  echo "client info"
  echo "client tracking on bcast $args"
  echo "client info"
} | "$VALKEY_CLI" -p "$PORT" > out.txt
before=$(grep -o 'tot-mem=[0-9]*' out.txt | sed -n 1p | cut -d= -f2)
after=$(grep -o 'tot-mem=[0-9]*' out.txt | sed -n 2p | cut -d= -f2)
diff=$((after - before))
if [ "$diff" -lt 120000 ]; then echo "overhead ok"; else echo "overhead too large"; fi
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
