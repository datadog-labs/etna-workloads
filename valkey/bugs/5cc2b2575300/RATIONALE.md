# Rationale

Fix: 5cc2b2575300 (CLUSTER SLOTS/NODES show wrong port for myself after `config set port/tls-port`). Reverted all hunks in 9.0.7:

- `config.c` `updatePort`: removed `clusterUpdateMyselfAnnouncedPorts()` (fix hunk adding it before `changeListener`). Same code location, still present identically in 9.0.7.
- `config.c` `applyTLSPort`: removed the same call (fix hunk 3).
- `config.c` `updateClusterAnnouncedPort`: re-added `clearCachedClusterSlotsResponse()` (fix removed it, because the save-config todo now clears the cache). Needed because `clusterUpdateMyselfAnnouncedPorts` no longer schedules the save below.
- `cluster_legacy.c` `clusterUpdateMyselfAnnouncedPorts` and `clusterUpdateMyselfIp`: removed `clusterDoBeforeSleep(CLUSTER_TODO_SAVE_CONFIG)` (fix hunks 1-2). That todo flag is what clears the cached CLUSTER SLOTS response and persists nodes.conf.

Effect: changing `port`/`tls-port` at runtime leaves myself->tcp_port/tls_port stale and the slots cache uncleared.

Oracle: "Test change port and tls-port on runtime" fails (CLUSTER NODES on node 0 still shows the old port / cached CLUSTER SLOTS assert in clusterCommandSlots). The other two oracle cases still pass.
