# Rationale

Fix (gh-143930) added `BaseBrowser._check_url()` and called it from every `open()` in Lib/webbrowser.py.
In v3.15.2 the hunks still apply textually but the helper's message changed and the UnixBrowser call
became `self._check_url(url.replace("%action", action))` (also covering the `%action` case).

Change: removed every `self._check_url(...)` call in Lib/webbrowser.py (GenericBrowser, BackgroundBrowser,
UnixBrowser, Konqueror, WindowsDefault, MacOS, MacOSXOSAScript, IOSBrowser), reversing each call-site hunk.
The helper definition is left (unused), as in the pre-fix code's absence of callers. URLs starting with
`-` are again passed to subprocesses as options.

Oracle: all `test_reject_dash_prefixes` cases (Generic, Background, Chrome, Mozilla, ELinks, ...) and
`test_reject_action_dash_prefixes` fail with "ValueError not raised" (9 failures).
