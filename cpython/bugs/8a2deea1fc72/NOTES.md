Drives a mocked UnixConsole (as in test_unix_console.test_no_newline) with the single keypress "1" and
checks whether a "\n" was written via os.write. Clean: no newline (False). Buggy: the first refresh
moves/writes "\n" when the screen is empty, overwriting prior output (True).
