Pushes a non-ASCII `str` ("ñ") into a Unix `_pyrepl` EventQueue with an empty keymap.
Clean: the `assert isinstance(char, (int, bytes))` in `BaseEventQueue.push` raises AssertionError -> prints `AssertionError`.
Buggy: the assert is removed and str is accepted -> prints `no error`.
(check.sh fails in this sandbox on a bwrap path error; ran both interpreters directly.)
