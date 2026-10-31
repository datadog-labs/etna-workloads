Mocks `subprocess._fork_exec` to write invalid data (`b"\xff\x00\xde\xad"`) to the error pipe, then constructs a Popen.
Clean: raises `SubprocessError: Bad exception data from child: b'\xff\x00\xde\xad'`.
Buggy: the error path concatenates bytes with str and raises `TypeError: can't concat str to bytes`.
