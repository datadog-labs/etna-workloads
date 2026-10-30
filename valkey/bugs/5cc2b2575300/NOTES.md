Starts a single-node cluster with all slots, calls CLUSTER SLOTS (populating the cache),
then `config set port PORT+2` and queries the new port.
Clean: CLUSTER NODES and CLUSTER SLOTS show the new port for myself (counts 1, 1).
Buggy: myself's port isn't updated (updatePort no longer calls clusterUpdateMyselfAnnouncedPorts), so both counts are 0.
