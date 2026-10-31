repro.py passes a spawn-context SimpleQueue to a child process (so it is unpickled via __setstate__) and calls q.empty() there.
Clean: prints True, exit code 0. Buggy: __setstate__ no longer sets self._poll, so the child raises AttributeError ('SimpleQueue' object has no attribute '_poll') and exits with code 1.
