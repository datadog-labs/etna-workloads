Calls the loop's internal `_ensure_resolved` with an IPv6 address tuple carrying scope id 1.
Clean: resolved sockaddr is `('fe80::1', 80, 0, 1)`. Buggy: scope id discarded, `('fe80::1', 80, 0, 0)`.
