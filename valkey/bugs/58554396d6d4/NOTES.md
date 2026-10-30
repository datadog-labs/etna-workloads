Replicates INCRBYFLOAT on a key with EX; replica TTL should stay positive. Buggy build drops KEEPTTL in the rewritten SET so replica TTL becomes -1.
