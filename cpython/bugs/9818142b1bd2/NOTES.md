Reproducer: creates a socket with SOCK_STREAM|SOCK_NONBLOCK and prints sock.type, also after setblocking/settimeout. Clean: always SOCK_STREAM. Buggy: type keeps/toggles the SOCK_NONBLOCK flag.
