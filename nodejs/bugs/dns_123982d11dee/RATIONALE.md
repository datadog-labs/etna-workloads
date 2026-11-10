# Bug
`dns.lookup()` with an `order` option ignored it: the code read the nonexistent `options.dnsOrder`, so `dnsOrder` became undefined and the default order was used instead of 'ipv4first'/'ipv6first'/'verbatim'.

# Change
lib/dns.js, in `lookup()`: `dnsOrder = options.order;` -> `dnsOrder = options.dnsOrder;`. This matches the single implementation hunk of the fix, reversed.

# Failing test
parallel/test-dns-default-order-verbatim: "not ok", AssertionError: Expected values to be strictly equal (expected: 1, ...) in the `{ order: 'ipv4first' }` check. Stable over 2 runs.
