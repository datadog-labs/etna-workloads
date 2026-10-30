Starts a 3-node cluster, publishes on node 0, and prints `cluster_stats_messages_publish_sent`.
Clean: `cluster_stats_messages_publish_sent:2`. Buggy: the line is missing, because the publish
message type carries a modifier bit that is no longer masked off when counting sent messages.
