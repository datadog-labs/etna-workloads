repro.py calls cmd.Cmd.complete() directly (readline functions stubbed, no pty) for the lines "! h" and "!h" on a Cmd subclass without do_shell.
Clean: both complete via completedefault and print "hello".
Buggy: parseline returns cmd=None, `cmd == ''` is false, so `'complete_' + None` raises TypeError.
