import os, sys
from unittest.mock import MagicMock, patch
sys.path.insert(0, os.path.join(os.path.dirname(os.__file__), "test"))
from test.test_pyrepl.support import handle_all_events, code_to_events
from _pyrepl.console import Event
from _pyrepl.unix_console import UnixConsole

def unix_console(events):
    console = UnixConsole(term="xterm")
    console.get_event = MagicMock(side_effect=events)
    console.getpending = MagicMock(return_value=Event("key", ""))
    console.getheightwidth = MagicMock(return_value=(25, 80))
    console.wait = MagicMock()
    console.prepare()
    return console

attrs = [27394, 3, 19200, 536872399, 38400, 38400, [b"\x00"] * 20]
with patch("termios.tcgetattr", lambda _: attrs), \
     patch("termios.tcsetattr", lambda a, b, c: None), \
     patch("os.write") as w:
    _, con = handle_all_events(code_to_events("1"), prepare_console=unix_console)
    print("newline written:", any(c.args[1] == b"\n" for c in w.mock_calls))
    con.restore()
