Starts two cluster-enabled primaries with `hz 1`, loads 1000 keys in slot 16383 on node 2,
and runs `CLUSTER MIGRATESLOTS` to move the slot to node 1. It then prints the key count
in the slot on both nodes.

Clean: node 1 gets all 1000 keys and node 2 has 0.
Buggy: the migration never completes within 20s, so node 1 has 0 keys and node 2 still has 1000.
The cause is that the ACK in the cron runs every second, which is every cron loop at hz 1, so the snapshot never proceeds.
