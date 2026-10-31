Calls loop._accept_connection with a fake listening socket and prints how many times accept() is called per backlog. Clean: backlog+1 (0->1, 1->2, 5->6); buggy: backlog (0->0, ...).
