import itertools, functools
from test.test_pyrepl.support import handle_all_events, code_to_events, prepare_reader
from _pyrepl.console import Event

def k(data, raw):
    return Event(evt="key", data=data, raw=bytearray(raw))

code = "def foo():\na = 1\n"
events = itertools.chain(
    code_to_events(code),
    [
        k("up", b"\x1bOA"), k("up", b"\x1bOA"), k("\x05", b"\x1bO5"),
        k("\n", b"\n"), k("\n", b"\n"),
        k("down", b"\x1bOB"), k("\x05", b"\x1bO5"),
        k("\n", b"\n"), k("\n", b"\n"),
    ],
)
reader, _ = handle_all_events(events, prepare_reader=functools.partial(prepare_reader, paste_mode=False))
print(reader.finished)
print(repr(reader.get_unicode()))
