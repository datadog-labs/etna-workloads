Starts a 3-node cluster (two primaries with slots, one empty), then runs
`valkey-cli --cluster del-node` on the empty reachable node.
Clean prints `[OK] Node <id> removed from the cluster.`; buggy omits that line
(the success message was added by the fix). Node ID is masked.
