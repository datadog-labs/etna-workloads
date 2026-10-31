Feeds "def f():\n    pass\n" then Ctrl+D to a _pyrepl ReadlineAlikeReader (mocked console).
Fixed: Ctrl+D after a trailing newline finishes input -> `True 'def f():\n    pass\n'`.
Buggy: Ctrl+D is a no-op there -> `reader.finished` is `False`.
