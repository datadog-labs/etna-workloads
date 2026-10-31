Runs a child that reads stdin to EOF, then calls `Process.communicate(None)`.
Clean: stdin is closed, child prints `b'0\n'`, returncode 0.
Buggy: communicate() only feeds/closes stdin when input is not None, so the child never sees EOF and the 5s wait_for times out ("timeout: ...").
