# Rationale

In 9.0.7 `clusterUpdateMyselfAnnouncedPorts()` and `updateClusterAnnouncedPort` already exist (cluster_legacy.c / config.c), so the fix's new function cannot be reversed as a patch. The change is in the third fix hunk, where the config table registered the apply callback.

## Change (src/config.c, static_configs)
`cluster-announce-bus-port`, `cluster-announce-port` and `cluster-announce-tls-port` now have `NULL` as their apply function instead of `updateClusterAnnouncedPort`. This reverses the fix's config.c table hunk. The code is equivalent to the pre-fix state: `CONFIG SET` changes `server.cluster_announce_*` but `myself->tcp_port/tls_port/cport` is not re-derived. As a result, `CLUSTER NODES` on the local node keeps showing the old ports. Gossip headers are still built from `deriveAnnouncedPorts` directly, so only the local view is stale.

The client-port configs (added later) and the `updatePort`/`updateTLSPort` calls are not part of this fix and were left alone.

## Oracle failures
All 3 cases in tests/unit/cluster/announced-endpoints.tcl fail. After `config set cluster-announce-port/tls-port`, `CLUSTER NODES` on R 0 still shows the old port instead of `*:$used_port@*`. After `config set cluster-announce-bus-port`, it still shows the old bus port instead of `*@$used_port *`.
