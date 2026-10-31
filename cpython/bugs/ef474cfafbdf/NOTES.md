Reproducer: create_subprocess_exec with stderr=PIPE while loop.connect_read_pipe is
mocked to raise CancelledError (as in test_subprocess_read_pipe_cancelled).

Clean: prints "cancelled" / "done", no warnings. Buggy (missing the `_pipes_connected`
check in `_try_finish`): the transport never finishes, so the pipe is leaked and a
"ResourceWarning: unclosed file <_io.FileIO name=6 ...>" appears on stderr at exit.
(The upstream tests hang/fail on waiting for the process exit in this state; the
visible difference here is the leaked-pipe ResourceWarning.)
