repro.py uses a fake socket, calls set_tunnel('[1:2:3::4]:1234') and issues a PUT, then prints the bytes sent.
Clean: the first line is `CONNECT [1:2:3::4]:1234 HTTP/1.1`.
Buggy: it is `CONNECT 1:2:3::4:1234 HTTP/1.1`, because the IPv6 address is not re-wrapped in brackets.
