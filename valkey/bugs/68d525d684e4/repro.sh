#!/bin/bash
mkdir -p data bin
ln -sf "$(readlink -f "$VALKEY_SERVER")" bin/valkey-check-aof
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly yes --aof-use-rdb-preamble yes --dir "$PWD/data" --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" set foo bar
"$VALKEY_CLI" -p "$PORT" bgrewriteaof >/dev/null
while [ "$("$VALKEY_CLI" -p "$PORT" info persistence | grep -c 'aof_rewrite_in_progress:0')" != 1 ]; do sleep 0.1; done
sleep 0.5
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
head -c 6 data/appendonlydir/appendonly.aof.*.base.rdb; echo
bin/valkey-check-aof data/appendonlydir/appendonly.aof.manifest 2>&1 | sed 's/appendonly[^ ]*base[^ ]*/BASE/g' | grep -E "Start to check BASE|is valid|invalid|All AOF" 
echo "exit=${PIPESTATUS[0]}"
