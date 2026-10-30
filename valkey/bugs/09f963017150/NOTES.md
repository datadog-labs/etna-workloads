Starts a server with --loglevel verbose and --hide-user-data-from-log yes/no, sends a malformed
bulk length (`$blabla`) over a raw socket, and checks the log for the "Query buffer: ..." line.
Clean: "Query buffer: *redacted*" with hide=yes, and the raw "Query buffer: '...blabla'" with hide=no.
Buggy: the line is "Query buffer during protocol error: ..." so neither marker matches and nothing is printed.
