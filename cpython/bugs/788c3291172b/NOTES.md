Reproducer: starts a server with serve_forever(), connects a client that stays open, cancels the serve_forever task, then awaits wait_closed() under a 0.5s timeout.
Clean: prints "closed" (the cancel path calls close_clients()). Buggy: close_clients() is missing, so wait_closed() hangs on the open client and prints "timeout".
