Reproducer: create zset `dst`, run `ZRANGESTORE dst missing 0 -1` (missing source key), then `EXISTS dst`.
Clean: replies 0 and deletes `dst` (EXISTS -> 0). Buggy: replies an empty array and leaves `dst` intact (EXISTS -> 1).
