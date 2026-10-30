Starts a single-node cluster (all slots), runs `eval "redis.call('set','foo','bar')" 1 bar` (undeclared key in a different slot), then prints CLUSTER COUNTKEYSINSLOT for foo's slot (12182) and bar's slot (5061).
Clean: 1 / 0. Buggy: 0 / 1 (the key is written to the pre-declared key's slot).
