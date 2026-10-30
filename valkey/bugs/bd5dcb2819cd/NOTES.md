## What the reproducer does

Starts a single-node, cluster-enabled Valkey server owning all 16384 slots.

1. Opens a raw TCP connection and sends `CLIENT ID` followed by `SSUBSCRIBE
   channel0` on it, keeping the connection open (this is the client that
   will be killed).
2. Through `valkey-cli`, runs `MULTI`, `SET k v`, `CLIENT KILL ID <id of the
   subscriber>`, `EXEC`.
3. Checks that the server is still alive (`PING`) and that the log does not
   contain `ASSERTION FAILED`.

This mirrors the upstream test `SSUBSCRIBE client killed during transaction`
added by the fix commit: a client inside a `MULTI/EXEC` transaction executes
a normal keyed command (`SET k v`, which sets the executing client's cached
slot) and then kills another client that is subscribed to a shard pubsub
channel. Freeing the killed client's pubsub state calls
`pubsubUnsubscribeChannel`, which needs the slot of the channel being
unsubscribed.

## What differs between the builds

- Clean (fixed) build: `pubsubUnsubscribeChannel` computes the slot directly
  from the channel name with `keyHashSlot()`, and initializes `found` to
  `NULL`. The transaction completes normally (`EXEC` returns `OK` and `1`),
  and the server keeps responding to `PING`.

- Buggy build (`injection.patch` reverts the fix): the slot is instead taken
  from `getKeySlot()`, which returns the *executing* client's cached slot
  (the slot of key `k` from the preceding `SET`), not the slot of
  `channel0`. The hashtable lookup for the channel in the wrong slot's
  hashtable fails, `found` is left uninitialized, and the subsequent
  `serverAssertWithInfo(c, NULL, found)` can pass on garbage, leading to
  memory corruption. In practice this reproducer crashes the server with a
  segmentation fault while processing `EXEC`: the CLI connection drops with
  "Server closed the connection", and the following `PING` fails to connect
  because the server process has died.
