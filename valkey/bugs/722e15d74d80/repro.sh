#!/bin/bash
S="$VALKEY_SERVER"; C="$VALKEY_CLI"; P="$PORT"
start() {
  "$S" --port "$P" --save "" --appendonly yes --appendfsync always --aof-load-truncated yes --dir . --logfile s.log &
  for i in $(seq 100); do "$C" -p "$P" ping >/dev/null 2>&1 && return; sleep 0.1; done
}
start
"$C" -p "$P" set foo hello
"$C" -p "$P" shutdown nosave
sleep 0.5
f=$(ls appendonlydir/*.incr.aof)
printf '*1\r\n$5\r\nmulti\r\n*3\r\n$3\r\nset\r\n$3\r\nbar\r\n$5\r\nworld\r\n*1\r\n$4\r\nex' >> "$f"
start
"$C" -p "$P" get foo
"$C" -p "$P" get bar
"$C" -p "$P" set baz survived
"$C" -p "$P" shutdown nosave
sleep 0.5
start
"$C" -p "$P" get foo
"$C" -p "$P" get bar
"$C" -p "$P" get baz
"$C" -p "$P" shutdown nosave
