Runs two statements through `InteractiveColoredConsole.runsource`: the first raises, the second prints.
Clean: execution stops after the exception, so 'spam&eggs' is not printed (output: `True`).
Buggy: runcode no longer reports failure, so the second statement still runs and prints `spam&eggs` before `True`.
