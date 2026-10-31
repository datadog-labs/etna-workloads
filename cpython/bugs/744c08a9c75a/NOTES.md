Calls asyncio.create_subprocess_exec with pathlib.Path (os.PathLike) arguments.
Clean: both subprocesses run, prints 0 and 0. Buggy: base_events.subprocess_exec
raises TypeError("program arguments must be a bytes or text string, not PosixPath").
