#!/bin/bash
# Reproducer for: zipmap value-length integer overflow in zipmapValidateIntegrity
# (fixed upstream by 3c634b6972f0289e7ffe8480568b4e8431095177).
#
# A crafted zipmap RESTORE payload sets the value length to 0xFFFFFFFF with a
# 1-byte free space, so 'l + e' wraps to 0 in 32-bit arithmetic. The buggy
# validator advances its cursor by the wrapped (tiny) amount instead of
# rejecting the payload outright, so the corruption is caught later -- if at
# all -- deeper in the loading code, logging a different message than the
# fixed validator does.
set -u

LOG=s.log

"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . \
    --logfile "$LOG" --loglevel verbose --enable-debug-command yes &
SERVER_PID=$!

for i in $(seq 1 100); do
    "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break
    sleep 0.1
done

"$VALKEY_CLI" -p "$PORT" debug set-skip-checksum-validation 1

# The payload contains embedded NUL bytes, which cannot survive as a bash /
# argv argument (C strings are NUL-terminated), so redis-cli can't be used
# here. Send the RESTORE command as raw RESP directly over a socket instead.
exec 3<>"/dev/tcp/127.0.0.1/$PORT"
printf '*4\r\n$7\r\nRESTORE\r\n$3\r\nkey\r\n$1\r\n0\r\n$24\r\n\x09\x0c\x01\x03\x66\x6f\x6f\xfe\xff\xff\xff\xff\x01\xff\x0b\x00\x00\x00\x00\x00\x00\x00\x00\x00\r\n' >&3
RESTORE_REPLY=
read -r -t 2 -u3 RESTORE_REPLY
exec 3<&-
exec 3>&-
echo "RESTORE reply: $RESTORE_REPLY"

echo "PING: $("$VALKEY_CLI" -p "$PORT" ping)"

if grep -q "Zipmap integrity check failed" "$LOG"; then
    echo "LOG: zipmap integrity check rejected the payload"
elif grep -q "Hash zipmap with dup elements, or big length" "$LOG"; then
    echo "LOG: zipmap integrity check WRONGLY ACCEPTED the payload (caught later, deeper in loading)"
else
    echo "LOG: unexpected, no matching corruption message found"
fi

"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait "$SERVER_PID" 2>/dev/null
