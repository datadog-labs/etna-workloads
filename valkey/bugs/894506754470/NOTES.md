Builds a 4-node cluster by hand (2 masters, 2 replicas), sets FOO on master 0, then moves its slot to master 1 via bumpepoch + setslot node (gossip ownership transfer).
Clean: master and replica both end with 0 keys in the slot. Buggy: the master deletes the key but the deletion isn't propagated, so the replica still has it ("replica keys after: 1").
