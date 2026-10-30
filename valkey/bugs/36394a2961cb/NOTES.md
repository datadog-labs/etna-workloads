Reproducer for the "blocking command followed by partial pipelined command" deadlock.
repro.sh opens a raw TCP socket, sends CLIENT ID, then BLPOP mylist 0 plus the first half of a pipelined SET,
then the rest of the SET while the client is blocked, then RPUSHes from another connection.
Clean: client gets the BLPOP reply and +OK, and GET key returns "value".
Buggy: the queued partial SET is never re-parsed, so +OK never arrives and GET key is empty.
