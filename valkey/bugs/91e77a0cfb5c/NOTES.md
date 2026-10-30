repro.sh starts one server and runs `zpopmin/zpopmax` with count 0 or negative counts on a string key and on a real zset.

Clean build: count 0 on a string key returns WRONGTYPE, and negative counts return "ERR value is out of range, must be positive".
Buggy build: all of these return an empty array, with no type check and no error.
