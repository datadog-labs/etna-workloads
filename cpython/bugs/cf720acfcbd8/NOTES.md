repro.py feeds request lines with malformed HTTP versions (`HTTP/-9_9_9.+9_9_9`, `HTTP/909876543210.0`, `HTTP/1.909876543210`) straight to `BaseHTTPRequestHandler.parse_request` using in-memory streams (no sockets), and prints the status line written.

Clean: all three get `400 Bad request version`.
Buggy: the digit/length checks are gone, so signs/underscores and long numbers are accepted by `int()`. The first and third produce no error response, and the second gets `505 Invalid HTTP version`.

Note: `./check.sh` failed in this sandbox (bwrap missing `.claude/launch.json`), so I ran both interpreters by hand instead.
