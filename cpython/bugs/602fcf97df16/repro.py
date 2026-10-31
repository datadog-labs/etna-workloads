from unittest.mock import MagicMock
from _pyrepl.console import Event
from _pyrepl.readline import ReadlineAlikeReader, ReadlineConfig

console = MagicMock()
console.get_event.side_effect = [
    Event(evt="key", data=c, raw=bytearray(c.encode()))
    for c in "if some_condition:\nsome_function()"
]
console.height = 100
console.width = 10
console.getheightwidth = MagicMock(side_effect=lambda: (100, 10))

reader = ReadlineAlikeReader(console=console, config=ReadlineConfig())
reader.more_lines = lambda text: text.endswith(":")
reader.ps1 = reader.ps2 = ">>> "
reader.ps3 = "... "
reader.ps4 = ""
reader.can_colorize = False
reader.paste_mode = False
try:
    while True:
        reader.handle1()
except StopIteration:
    pass
for line in reader.screen:
    print(repr(line))
