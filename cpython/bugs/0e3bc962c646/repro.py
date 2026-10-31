import os, sys, importlib, rlcompleter
from _pyrepl.console import Event
from _pyrepl.readline import ReadlineAlikeReader, ReadlineConfig
from _pyrepl._module_completer import ModuleCompleter
from test.test_pyrepl.support import FakeConsole
sys.path = [os.path.dirname(importlib.__path__[0])]

for code in ("import pri\t\n", "from pri\t\n", "from typong import Na\t\n"):
    events = [Event(evt="key", data=c, raw=bytearray(c.encode())) for c in code]
    config = ReadlineConfig()
    config.module_completer = ModuleCompleter({})
    config.readline_completer = rlcompleter.Completer({}).complete
    reader = ReadlineAlikeReader(console=FakeConsole(events), config=config)
    print(repr(reader.readline()))
