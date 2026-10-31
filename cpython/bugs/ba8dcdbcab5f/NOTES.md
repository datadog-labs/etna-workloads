repro.py: starts a local IPv4 server, then calls loop.create_connection(..., local_addr=('fake-local', 0)),
with loop.getaddrinfo patched so the local address resolves only to an AF_INET6 address (::1).
Clean: local addresses of a different family are skipped, so it raises
`OSError: no matching local address with family=AF_INET found` (printed, exit 0).
Buggy: the family check is gone, so an IPv6 sockaddr is bound on an AF_INET socket and a
TypeError ("AF_INET address must be a pair") escapes instead of OSError (traceback, exit 1).
