# Re-introduced bug: compare_ipv4() compares in network byte order

**Bug:** `compare_ipv4()` in `src/node_sockaddr.cc` compared `sin_addr.s_addr` values directly. Those values are in network byte order. On little-endian hosts the numeric comparison is therefore wrong, so ordering of IPv4 addresses is wrong. BlockList `addRange()` checks (e.g. 10.0.0.2-10.0.0.10) give wrong results (nodejs/node#39074).

**Hunk:** The fix added `ntohl()` when loading `s_addr_one` and `s_addr_two`, and compared those. In today's code (which returns `std::partial_ordering`), the same two locals exist. I removed the `ntohl()` calls, so they hold the raw network-order values again. This is the pre-fix behaviour.

**Failing test:** `parallel/test-blocklist` reports `not ok`. It fails on the new range regression block, which checks `10.0.0.2`-`10.0.0.10` ranges. The failure is stable across two runs.
