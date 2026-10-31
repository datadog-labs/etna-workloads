repro.py inflates sys.argv to ~250 KB (5000 x 50-char args), then starts a Process via the forkserver
context with `__main__` preloaded (so sys.argv is forwarded to the forkserver).
Clean: the argv is passed as real argv elements; worker prints `worker:5002:sentinel`, exitcode 0.
Buggy: argv is repr'd into the single `-c` string, exceeding MAX_ARG_STRLEN, so spawn fails and
p.start() raises BrokenPipeError.
