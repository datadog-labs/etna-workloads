# Rationale

Both hunks of the fix touch `Lib/asyncio/base_events.py::_connect_sock`; both are reverted there.

1. Loop over `local_addr_infos`: restored `for _, _, _, _, laddr in local_addr_infos:` and removed the
   `if lfamily != family: continue` check. Local addresses of a different family are tried again for `sock.bind`.
2. `for/else` branch: restored the unconditional `raise my_exceptions.pop()` and removed the
   `if my_exceptions: ... else: raise OSError("no matching local address ...")` fallback.

Oracle failures: `test_create_connection_local_addr_skip_different_family` and
`test_create_connection_local_addr_nomatch_family`, across the event-loop subclasses (6 errors in total).
Binding an AF_INET socket to an AF_INET6 address raises `TypeError: AF_INET address must be a pair (host, port)`
instead of `OSError`, which is what the tests expect.
