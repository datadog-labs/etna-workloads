#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" acl setuser command-test -@all
"$VALKEY_CLI" -p "$PORT" acl dryrun command-test set somekey somevalue
"$VALKEY_CLI" -p "$PORT" acl dryrun command-test get somekey
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
