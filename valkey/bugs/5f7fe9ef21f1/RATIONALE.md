# Rationale

## Change (tree/src/cluster_legacy.c, clusterNodeCronHandleReconnect)
Removed the block that, for a node in normal state with an outbound link but no
inbound link for longer than the handshake timeout (and no recent MEET sent),
sets CLUSTER_NODE_MEET and sends a MEET packet over the outbound link.

This reverses the fix hunk in `clusterNodeCronHandleReconnect` that added
"Sending MEET packet to node ... because there is no inbound link for it".
In 9.0.7 the block has extra conditions (meet_sent throttle, nodeSupportsMultiMeet),
but it is the same logic; removing it restores the pre-fix behaviour where a node
whose handshake timed out on the peer's side is never re-MEETed.
The other fix parts (inbound_link_freed_time bookkeeping, nodeIn*State macros, freeing
the outbound link upon MEET from a known node) are left in place; they are inert
without the sender side, as before the fix they did not exist.

## Oracle failures
tests/unit/cluster/cluster-reliable-meet.tcl:
- "Handshake eventually succeeds after node handshake timeout on both sides with inconsistent view of the cluster"
- "Handshake eventually succeeds after node handshake timeout on one side with inconsistent view of the cluster"
Both fail with "all nodes should know each other": the cluster view stays inconsistent.
