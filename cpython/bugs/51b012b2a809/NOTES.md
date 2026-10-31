repro.py formats an ExceptionGroup with TracebackException.format(colorize=True) and checks whether the sub-exception section contains ANSI codes.
Clean: True. Buggy: False, because the injection drops colorize= when formatting nested exceptions.
