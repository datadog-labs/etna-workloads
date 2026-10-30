repro.sh: creates a hash with field1 (TTL 600s), then runs `HEXPIRE myhash 0 GT FIELDS 2 field1 field2` and HLEN.
Clean: replies `0 -2` and HLEN is 1 (GT blocks the past-time expiry).
Buggy: replies `2 -2` and field1 is deleted (HLEN 0), because the GT flag is ignored when the time is in the past.
