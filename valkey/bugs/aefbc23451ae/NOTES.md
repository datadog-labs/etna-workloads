repro.sh sets client-output-buffer-limit with malformed values ("10mbs" hard/soft, "60s" soft_seconds), then prints the config.
Clean: each CONFIG SET returns an error and the limits stay at defaults.
Buggy: the hard/soft/soft_seconds suffix checks are gone, so the bad values return OK and the limits are silently changed (e.g. "10mbs" parsed as 0).
