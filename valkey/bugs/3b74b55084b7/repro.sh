"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c config set acl-pubsub-default allchannels
c acl setuser default reset on nopass '~*' +@all
c acl setuser bob reset on nopass '~*' +@all
c acl getuser default | grep -A1 -i channels
c acl getuser bob | grep -A1 -i channels
c publish hello world | head -c 0; c acl setuser default reset on nopass "~*" +@all; c publish hello world
c shutdown nosave
wait
