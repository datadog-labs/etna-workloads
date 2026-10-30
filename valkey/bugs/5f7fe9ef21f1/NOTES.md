Reproducer: 3-node cluster (A, B, C). B and C meet. B drops PONGs and C drops MEETs
(DEBUG DROP-CLUSTER-PACKET-FILTER), then A meets B, so B's handshake with A times out
while A still knows B (and C via gossip). Filters are then removed.

Clean build: A sends a MEET to nodes with an outbound link but no inbound link, so all three
nodes end up knowing each other ("all nodes know each other").
Buggy build: that MEET is missing, so the view stays inconsistent ("views inconsistent").
