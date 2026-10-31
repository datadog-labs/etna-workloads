Calls `GenericBrowser.open("--key=val http://example.com")` with a nonexistent command.
Clean: raises ValueError (leading-dash URL rejected). Buggy: no check, so the
launch fails silently and `open` returns False.
