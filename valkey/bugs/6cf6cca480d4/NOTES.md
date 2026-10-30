Sets a key, then (inside one EVAL) DUMPs it, deletes it and RESTOREs it with TTL 9223372036854775807 (relative).
Clean: "ERR invalid expire time in 'restore' command", key absent (exists 0).
Buggy: no overflow check, so RESTORE succeeds ("restored") with a wrapped/negative expire; key exists state differs.
