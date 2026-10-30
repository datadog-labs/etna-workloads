Sends RESTORE with a string payload declaring length 0xFFFFFFFFFFFFFFF0 via valkey-cli -x.
Clean: "Bad data format" error, server still answers PONG.
Buggy: sdsnewlen asserts on size overflow, server aborts; ping fails to connect and the log has ASSERTION FAILED.
