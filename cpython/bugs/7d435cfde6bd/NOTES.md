Creates a selector socket transport on a socketpair, calls abort() (sets _conn_lost), then calls writelines() both before and after _call_connection_lost runs.
Clean: writelines is ignored after connection loss; buffer size prints 0 both times, exit 0.
Buggy: the _conn_lost check is missing, so data is buffered (prints 4), and after connection lost it calls a None _write_ready and raises TypeError (exit 1).
