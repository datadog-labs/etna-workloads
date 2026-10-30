#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" config resetstat
printf 'MULTI\nset foo{t} bar\nGEOADD foo2{t} 0 0 bar\nEXPIRE foo2{t} 0\nEXEC\n' | "$VALKEY_CLI" -p "$PORT"
"$VALKEY_CLI" -p "$PORT" info commandstats | grep -E 'cmdstat_(multi|exec|set|expire|geoadd):' | sed 's/,usec.*//' | sort
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
