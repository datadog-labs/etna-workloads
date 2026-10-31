Mocks a listening socket whose accept() raises ConnectionAbortedError every other call, then runs
loop._accept_connection with backlog=100 and prints sock.accept.call_count.
Clean: 101 (aborted connections are skipped, loop continues). Buggy: 2 (returns early on the first abort).
