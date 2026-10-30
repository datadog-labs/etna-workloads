Starts a single cluster-enabled node, sets cluster-announce-port and cluster-announce-bus-port at runtime, and checks CLUSTER NODES / CLUSTER SLOTS.
Clean: the new ports show up immediately. Buggy: the config has no apply callback (updateClusterAnnouncedPort), so CLUSTER NODES/SLOTS keep the old ports (grep counts 0 instead of 1).
