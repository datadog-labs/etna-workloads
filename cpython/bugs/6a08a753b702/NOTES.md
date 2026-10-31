repro.py runs two lines through pyrepl's InteractiveColoredConsole.runsource: `from __future__ import barry_as_FLUFL`, then `print("black" <> 'blue')`. Clean prints 'True
' as the captured output. Buggy reports a SyntaxError (stderr) and captures '', because the injected change stops the future flag from carrying over to later input.
